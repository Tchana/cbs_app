import 'dart:async';
import 'dart:io';

import 'package:center_for_biblical_studies/data/authentication/login_data.dart';
import 'package:dio/dio.dart';
import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/data/message/message_data.dart';
import 'package:center_for_biblical_studies/data/message/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Replaces the previous REST API. Uses Supabase Auth + Database.
class SupabaseService {
  static SupabaseClient get _client => Supabase.instance.client;

  // ---------------------------------------------------------------------------
  // Auth (session is managed by Supabase; no manual token storage)
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> login(LoginData data) async {
    try {
      await _client.auth.signInWithPassword(
        email: data.email?.trim() ?? '',
        password: data.password ?? '',
      );
      return {'success': true};
    } on AuthException catch (e) {
      final message = _friendlyAuthMessage(e.message);
      return {
        'error': true,
        'message': message,
        'status': 400,
      };
    } on SocketException catch (_) {
      return {
        'error': true,
        'message': 'No internet connection. Check your network and try again.',
        'status': 0,
      };
    } on TimeoutException catch (_) {
      return {
        'error': true,
        'message': 'Connection timed out. Please try again.',
        'status': 0,
      };
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('SocketException') ||
          msg.contains('Failed host lookup') ||
          msg.contains('Connection')) {
        return {
          'error': true,
          'message': 'Cannot reach server. Check your internet and try again.',
          'status': 0,
        };
      }
      return {
        'error': true,
        'message': msg.length > 120 ? 'Login failed. Please try again.' : msg,
        'status': 400,
      };
    }
  }

  /// Map Supabase auth errors to user-friendly messages.
  String _friendlyAuthMessage(String? raw) {
    if (raw == null || raw.isEmpty) return 'Login failed. Please try again.';
    final lower = raw.toLowerCase();
    if (lower.contains('invalid login') ||
        lower.contains('invalid credentials')) {
      return 'Invalid email or password.';
    }
    if (lower.contains('email not confirmed') ||
        lower.contains('confirm your email')) {
      return 'Please confirm your email before signing in.';
    }
    if (lower.contains('too many'))
      return 'Too many attempts. Try again later.';
    return raw;
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: name != null && name.trim().isNotEmpty
            ? {'name': name.trim(), 'first_name': name.trim()}
            : null,
      );
      final session = response.session;
      final user = response.user;
      if (user == null) {
        return {
          'error': true,
          'message': 'Registration failed. Please try again.',
          'status': 400,
        };
      }
      if (session != null) {
        return {'success': true};
      }
      return {
        'success': true,
        'requiresEmailConfirmation': true,
      };
    } on AuthException catch (e) {
      final message = e.message.isEmpty
          ? 'Registration failed. Please try again.'
          : e.message;
      return {
        'error': true,
        'message': message,
        'status': 400,
      };
    } on SocketException catch (_) {
      return {
        'error': true,
        'message': 'No internet connection. Check your network and try again.',
        'status': 0,
      };
    } on TimeoutException catch (_) {
      return {
        'error': true,
        'message': 'Connection timed out. Please try again.',
        'status': 0,
      };
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('SocketException') ||
          msg.contains('Failed host lookup') ||
          msg.contains('Connection')) {
        return {
          'error': true,
          'message': 'Cannot reach server. Check your internet and try again.',
          'status': 0,
        };
      }
      return {
        'error': true,
        'message':
            msg.length > 120 ? 'Registration failed. Please try again.' : msg,
        'status': 400,
      };
    }
  }

  // ---------------------------------------------------------------------------
  // Courses
  // ---------------------------------------------------------------------------

  Future<List<CourseData>> fetchCourses() async {
    final res = await _client
        .from('courses')
        .select('*, teacher:profiles(*), lessons:lessons(*)')
        .order('created_at', ascending: false);

    return (res as List)
        .map((row) => _courseFromRow(row as Map<String, dynamic>))
        .toList();
  }

  CourseData _courseFromRow(Map<String, dynamic> row) {
    final teacher = row['teacher'];
    final lessonsList = row['lessons'] as List<dynamic>?;
    return CourseData(
      id: row['id']?.toString(),
      title: row['title'] as String?,
      teacher: teacher != null
          ? _profileToRegisterData(teacher as Map<String, dynamic>)
          : null,
      description: row['description'] as String?,
      level: row['level'] as String?,
      lessons: lessonsList
          ?.map((e) => _lessonFromRow(e as Map<String, dynamic>))
          .toList(),
    );
  }

  LessonData _lessonFromRow(Map<String, dynamic> row) {
    return LessonData(
      id: row['id']?.toString(),
      course: row['course_id']?.toString(),
      title: row['title'] as String?,
      description: row['description'] as String?,
      file: row['file_url'] as String?,
    );
  }

  RegisterData _profileToRegisterData(Map<String, dynamic> p) {
    return RegisterData(
      id: p['id']?.toString(),
      email: p['email'] as String?,
      firstName: p['first_name'] as String?,
      lastName: p['last_name'] as String?,
      pImage: p['avatar_url'] as String?,
      role: p['role'] as String?,
    );
  }

  // ---------------------------------------------------------------------------
  // Books (library)
  // ---------------------------------------------------------------------------

  Future<List<LibraryData>> fetchBooks() async {
    final res = await _client
        .from('books')
        .select()
        .order('created_at', ascending: false);
    return (res as List)
        .map((row) => _bookFromRow(row as Map<String, dynamic>))
        .toList();
  }

  LibraryData _bookFromRow(Map<String, dynamic> row) {
    String? cat = row['category'] as String?;
    BookType category = BookType.other;
    if (cat != null) {
      switch (cat) {
        case 'bible':
          category = BookType.bible;
          break;
        case 'commentary':
          category = BookType.commentary;
          break;
        case 'dictionnaire':
          category = BookType.dictionnaire;
          break;
        case 'concordance':
          category = BookType.concordance;
          break;
      }
    }
    return LibraryData(
      id: row['id']?.toString(),
      title: row['title'] as String?,
      author: row['author'] as String?,
      book: row['book_url'] as String?,
      category: category,
      bookCover: row['book_cover_url'] as String?,
      description: row['description'] as String?,
      language: row['language'] as String?,
    );
  }

  // ---------------------------------------------------------------------------
  // Teachers (profiles with role teacher)
  // ---------------------------------------------------------------------------

  Future<List<RegisterData>> fetchTeachers() async {
    final res = await _client.from('profiles').select().eq('role', 'teacher');
    return (res as List)
        .map((e) => _profileToRegisterData(e as Map<String, dynamic>))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Rooms (forum groups)
  // ---------------------------------------------------------------------------

  Future<List<GroupData>> fetchGroups() async {
    final res = await _client
        .from('rooms')
        .select()
        .eq('is_deleted', false)
        .order('created_at', ascending: false);

    final list = res as List;
    final groups = <GroupData>[];
    for (final row in list) {
      final g = row as Map<String, dynamic>;
      final id = g['id']?.toString();
      int count = 0;
      if (id != null) {
        try {
          final rpc = await _client
              .from('room_participants')
              .select('room_id')
              .eq('room_id', id);
          count = (rpc as List).length;
        } catch (_) {}
      }
      groups.add(_groupFromRow(g, participantsCount: count));
    }
    return groups;
  }

  GroupData _groupFromRow(Map<String, dynamic> row, {int? participantsCount}) {
    return GroupData(
      uuid: row['id']?.toString(),
      name: row['name'] as String?,
      description: row['description'] as String?,
      created_at: row['created_at']?.toString(),
      created_by: row['created_by']?.toString(),
      is_private: row['is_private'] as bool?,
      is_deleted: row['is_deleted'] as bool?,
      deleted_at: row['deleted_at']?.toString(),
      deleted_by: row['deleted_by']?.toString(),
      participants_count:
          participantsCount ?? row['participants_count'] as int?,
      online_count: row['online_count'] as int? ?? 0,
      can_delete: true,
    );
  }

  Future<Map<String, dynamic>> createGroup({
    required String name,
    required String description,
    bool isPrivate = false,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return {'error': true, 'message': 'Not authenticated', 'status': 401};
    }
    try {
      final res = await _client
          .from('rooms')
          .insert({
            'name': name,
            'description': description,
            'is_private': isPrivate,
            'created_by': userId,
          })
          .select()
          .single();

      return {
        'success': true,
        'data': _groupFromRow(Map<String, dynamic>.from(res as Map))
      };
    } on PostgrestException catch (e) {
      return {
        'error': true,
        'message': e.message,
        'status': e.code != null ? int.tryParse(e.code!) : 400
      };
    }
  }

  // ---------------------------------------------------------------------------
  // Messages
  // ---------------------------------------------------------------------------

  Future<List<MessageData>> fetchMessages(String roomUuid) async {
    final res = await _client
        .from('messages')
        .select('*, user:profiles(*)')
        .eq('room_id', roomUuid)
        .eq('is_deleted', false)
        .order('created_at', ascending: true);

    return (res as List)
        .map((row) => _messageFromRow(row as Map<String, dynamic>))
        .toList();
  }

  MessageData _messageFromRow(Map<String, dynamic> row) {
    final userMap = row['user'];
    UserData? user;
    if (userMap != null && userMap is Map<String, dynamic>) {
      user = UserData(
        uuid: userMap['id']?.toString(),
        firstName: userMap['first_name'] as String?,
        lastName: userMap['last_name'] as String?,
        email: userMap['email'] as String?,
        bio: userMap['bio'] as String?,
        online_status: userMap['online_status'] as bool?,
        last_seen: userMap['last_seen']?.toString(),
      );
    }
    return MessageData(
      uuid: row['id']?.toString(),
      room: row['room_id']?.toString(),
      user: user,
      content: row['content'] as String?,
      timestamp: row['created_at']?.toString(),
      message_type: row['message_type'] as String? ?? 'text',
      is_deleted: row['is_deleted'] as bool?,
      deleted_at: row['deleted_at']?.toString(),
    );
  }

  Future<Map<String, dynamic>> sendMessage({
    required String roomUuid,
    required String content,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return {'error': true, 'message': 'Not authenticated', 'status': 401};
    }
    try {
      final res = await _client
          .from('messages')
          .insert({
            'room_id': roomUuid,
            'user_id': userId,
            'content': content,
          })
          .select('*, user:profiles(*)')
          .single();

      return {
        'success': true,
        'data': _messageFromRow(Map<String, dynamic>.from(res as Map))
      };
    } on PostgrestException catch (e) {
      return {
        'error': true,
        'message': e.message,
        'status': e.code != null ? int.tryParse(e.code!) : 400
      };
    }
  }

  // ---------------------------------------------------------------------------
  // PDF (download from URL – e.g. Supabase Storage or external)
  // ---------------------------------------------------------------------------

  Future<File> fetchPdfData(String url) async {
    final dir = Directory.systemTemp;
    final filePath =
        '${dir.path}/downloaded_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ));
    await dio.download(url, filePath);
    return File(filePath);
  }
}
