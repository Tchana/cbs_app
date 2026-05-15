import 'package:shared_preferences/shared_preferences.dart';

class RecentAccessService {
  static const _recentCourseIdsKey = 'recent_course_ids';
  static const _recentBookIdsKey = 'recent_book_ids';
  static const _maxItems = 8;

  static Future<List<String>> getRecentCourseIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentCourseIdsKey) ?? <String>[];
  }

  static Future<List<String>> getRecentBookIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentBookIdsKey) ?? <String>[];
  }

  static Future<void> markCourseAccessed(String? courseId) async {
    final id = (courseId ?? '').trim();
    if (id.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_recentCourseIdsKey) ?? <String>[];
    current.remove(id);
    current.insert(0, id);
    if (current.length > _maxItems) {
      current.removeRange(_maxItems, current.length);
    }
    await prefs.setStringList(_recentCourseIdsKey, current);
  }

  static Future<void> markBookAccessed(String? bookId) async {
    final id = (bookId ?? '').trim();
    if (id.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_recentBookIdsKey) ?? <String>[];
    current.remove(id);
    current.insert(0, id);
    if (current.length > _maxItems) {
      current.removeRange(_maxItems, current.length);
    }
    await prefs.setStringList(_recentBookIdsKey, current);
  }
}

