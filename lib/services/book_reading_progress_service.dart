import 'dart:convert';

import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContinueReadingEntry {
  const ContinueReadingEntry({
    required this.book,
    required this.progress,
    this.currentPage,
    this.totalPages,
  });

  final LibraryData book;
  final double progress;
  final int? currentPage;
  final int? totalPages;
}

class _BookProgressRecord {
  const _BookProgressRecord({
    required this.currentPage,
    required this.totalPages,
    required this.progress,
    required this.lastReadAtMs,
  });

  final int currentPage;
  final int totalPages;
  final double progress;
  final int lastReadAtMs;

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'totalPages': totalPages,
        'progress': progress,
        'lastReadAtMs': lastReadAtMs,
      };

  static _BookProgressRecord? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final lastReadAtMs = (raw['lastReadAtMs'] as num?)?.toInt();
    if (lastReadAtMs == null) return null;

    final totalPages = (raw['totalPages'] as num?)?.toInt() ?? 0;
    var currentPage = (raw['currentPage'] as num?)?.toInt() ?? 0;
    var progress = (raw['progress'] as num?)?.toDouble();

    if (totalPages > 0 && currentPage > 0) {
      progress ??= (currentPage / totalPages).clamp(0.0, 1.0);
      currentPage = currentPage.clamp(1, totalPages);
    } else if (progress != null && progress > 0) {
      currentPage = currentPage > 0 ? currentPage : 1;
      progress = progress.clamp(0.0, 1.0);
    } else {
      return null;
    }

    return _BookProgressRecord(
      currentPage: currentPage,
      totalPages: totalPages,
      progress: progress.clamp(0.0, 1.0),
      lastReadAtMs: lastReadAtMs,
    );
  }
}

/// Local-only book reading progress by page (SharedPreferences on device).
class BookReadingProgressService {
  String _storageKey() {
    final userId =
        (Supabase.instance.client.auth.currentUser?.id ?? '').trim();
    return 'book_reading_progress_local_${userId.isEmpty ? 'guest' : userId}';
  }

  Future<Map<String, _BookProgressRecord>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey());
    if (raw == null || raw.isEmpty) return {};

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final out = <String, _BookProgressRecord>{};
      for (final entry in decoded.entries) {
        final record = _BookProgressRecord.fromJson(entry.value);
        if (record != null) {
          out[entry.key] = record;
        }
      }
      return out;
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveAll(Map<String, _BookProgressRecord> data) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = data.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_storageKey(), jsonEncode(encoded));
  }

  Future<int> getResumePage(String? bookId) async {
    final id = (bookId ?? '').trim();
    if (id.isEmpty) return 1;
    final all = await _loadAll();
    final record = all[id];
    if (record == null || record.totalPages <= 0) return 1;
    return record.currentPage.clamp(1, record.totalPages);
  }

  Future<double> getProgress(String? bookId) async {
    final id = (bookId ?? '').trim();
    if (id.isEmpty) return 0;
    final all = await _loadAll();
    return all[id]?.progress ?? 0;
  }

  /// Updates progress from the page the user is on (1-based [currentPage]).
  Future<void> recordPageProgress({
    required String? bookId,
    required int currentPage,
    required int totalPages,
  }) async {
    final id = (bookId ?? '').trim();
    if (id.isEmpty || totalPages <= 0 || currentPage <= 0) return;

    final page = currentPage.clamp(1, totalPages);
    final progress = (page / totalPages).clamp(0.0, 1.0);

    final all = await _loadAll();
    all[id] = _BookProgressRecord(
      currentPage: page,
      totalPages: totalPages,
      progress: progress,
      lastReadAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await _saveAll(all);
  }

  Future<void> ensureStarted(String? bookId) async {
    final id = (bookId ?? '').trim();
    if (id.isEmpty) return;
    final all = await _loadAll();
    if (all.containsKey(id)) return;
    // Will be set on first page report from the PDF viewer.
  }

  Future<ContinueReadingEntry?> resolveContinueReading(
    List<LibraryData> books,
  ) async {
    if (books.isEmpty) return null;

    final byId = {for (final b in books) if (b.id != null) b.id!: b};
    final all = await _loadAll();

    String? bestId;
    var bestLastRead = 0;
    for (final entry in all.entries) {
      if (!byId.containsKey(entry.key)) continue;
      final p = entry.value.progress;
      if (p <= 0 || p >= 0.995) continue;
      if (entry.value.lastReadAtMs >= bestLastRead) {
        bestLastRead = entry.value.lastReadAtMs;
        bestId = entry.key;
      }
    }

    if (bestId == null) return null;
    final record = all[bestId]!;
    return ContinueReadingEntry(
      book: byId[bestId]!,
      progress: record.progress,
      currentPage: record.currentPage,
      totalPages: record.totalPages,
    );
  }
}
