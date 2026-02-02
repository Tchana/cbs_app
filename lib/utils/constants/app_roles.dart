/// User role types in the app (profiles.role).
/// Matches Supabase schema: student, teacher, visitor, admin.
class AppRoles {
  AppRoles._();

  static const String student = 'student';
  static const String teacher = 'teacher';
  static const String visitor = 'visitor';
  static const String admin = 'admin';

  static const List<String> all = [student, teacher, visitor, admin];

  static bool isValidRole(String? role) => role != null && all.contains(role);

  /// Default role for new signups (used by DB default; app can reference this).
  static const String defaultRole = student;
}
