import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum RecentAccessKind { course, book }

class RecentAccessItem {
  const RecentAccessItem({
    required this.kind,
    required this.id,
    required this.accessedAtMs,
  });

  final RecentAccessKind kind;
  final String id;
  final int accessedAtMs;

  Map<String, dynamic> toJson() => {
        'k': kind == RecentAccessKind.course ? 'c' : 'b',
        'id': id,
        'at': accessedAtMs,
      };

  static RecentAccessItem? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = (raw['id'] as String?)?.trim() ?? '';
    if (id.isEmpty) return null;
    final at = (raw['at'] as num?)?.toInt();
    if (at == null) return null;
    final k = raw['k'] as String?;
    final kind = k == 'b' ? RecentAccessKind.book : RecentAccessKind.course;
    return RecentAccessItem(kind: kind, id: id, accessedAtMs: at);
  }
}

class RecentAccessService {
  static const _entriesKey = 'recent_access_entries_v2';
  static const _legacyCourseIdsKey = 'recent_course_ids';
  static const _legacyBookIdsKey = 'recent_book_ids';
  static const _maxItems = 5;

  static Future<List<RecentAccessItem>> getRecentEntries({
    int limit = _maxItems,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await _migrateLegacyIfNeeded(prefs);
    final entries = _decodeEntries(prefs.getString(_entriesKey));
    entries.sort((a, b) => b.accessedAtMs.compareTo(a.accessedAtMs));
    return entries.take(limit).toList();
  }

  static Future<void> markCourseAccessed(String? courseId) async {
    await _markAccessed(RecentAccessKind.course, courseId);
  }

  static Future<void> markBookAccessed(String? bookId) async {
    await _markAccessed(RecentAccessKind.book, bookId);
  }

  static Future<void> _markAccessed(
      RecentAccessKind kind, String? rawId) async {
    final id = (rawId ?? '').trim();
    if (id.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await _migrateLegacyIfNeeded(prefs);

    final entries = _decodeEntries(prefs.getString(_entriesKey))
      ..removeWhere((e) => e.kind == kind && e.id == id);

    entries.insert(
      0,
      RecentAccessItem(
        kind: kind,
        id: id,
        accessedAtMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    if (entries.length > _maxItems) {
      entries.removeRange(_maxItems, entries.length);
    }

    await prefs.setString(_entriesKey, _encodeEntries(entries));
  }

  static Future<void> _migrateLegacyIfNeeded(SharedPreferences prefs) async {
    if (prefs.containsKey(_entriesKey)) return;

    final courses = prefs.getStringList(_legacyCourseIdsKey) ?? <String>[];
    final books = prefs.getStringList(_legacyBookIdsKey) ?? <String>[];
    if (courses.isEmpty && books.isEmpty) return;

    var at = DateTime.now().millisecondsSinceEpoch;
    final entries = <RecentAccessItem>[];
    var ci = 0;
    var bi = 0;

    while (entries.length < _maxItems &&
        (ci < courses.length || bi < books.length)) {
      if (ci < courses.length) {
        final id = courses[ci++].trim();
        if (id.isNotEmpty) {
          entries.add(
            RecentAccessItem(
              kind: RecentAccessKind.course,
              id: id,
              accessedAtMs: at--,
            ),
          );
        }
      }
      if (entries.length >= _maxItems) break;
      if (bi < books.length) {
        final id = books[bi++].trim();
        if (id.isNotEmpty) {
          entries.add(
            RecentAccessItem(
              kind: RecentAccessKind.book,
              id: id,
              accessedAtMs: at--,
            ),
          );
        }
      }
    }

    entries.sort((a, b) => b.accessedAtMs.compareTo(a.accessedAtMs));
    await prefs.setString(_entriesKey, _encodeEntries(entries));
  }

  static List<RecentAccessItem> _decodeEntries(String? raw) {
    if (raw == null || raw.isEmpty) return <RecentAccessItem>[];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return <RecentAccessItem>[];
      return decoded
          .map(RecentAccessItem.fromJson)
          .whereType<RecentAccessItem>()
          .toList();
    } catch (_) {
      return <RecentAccessItem>[];
    }
  }

  static String _encodeEntries(List<RecentAccessItem> entries) {
    return jsonEncode(entries.map((e) => e.toJson()).toList());
  }
}
