import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/authentication/login_data.dart';
import 'package:dio/dio.dart';
import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/data/message/message_data.dart';
import 'package:center_for_biblical_studies/data/message/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Replaces the previous REST API. Uses Supabase Auth + Database.
class SupabaseService {
  const SupabaseService();
  const SupabaseService.testable();

  static SupabaseClient get _client => Supabase.instance.client;

  // ---------------------------------------------------------------------------
  // Auth (session is managed by Supabase; no manual token storage)
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> login(LoginData data) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: data.email?.trim() ?? '',
        password: data.password ?? '',
      );

      final user = res.user ?? _client.auth.currentUser;
      if (user == null) {
        return {
          'error': true,
          'message': 'Login failed. Please try again.',
          'status': 400,
        };
      }

      // Mobile app access is restricted to students and library users only.
      // If a teacher/admin signs in successfully (credentials valid), we still block app access.
      final profile = await _client
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();
      final role = (profile is Map<String, dynamic>)
          ? (profile['role'] ?? '').toString().trim()
          : '';
      final allowed = role == 'student' || role == 'library_user';
      if (!allowed) {
        await _client.auth.signOut();
        return {
          'error': true,
          'message':
              'This app is only available for Students and Library members. Please use the backoffice if you are an admin/teacher.',
          'status': 403,
        };
      }

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
    if (lower.contains('too many')) {
      return 'Too many attempts. Try again later.';
    }
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
        // Ensure mobile-created accounts are app-eligible.
        // The DB trigger `handle_new_user()` defaults `profiles.role` to 'teacher'
        // when no `role` meta is provided, which would block mobile login.
        data: {
          if (name != null && name.trim().isNotEmpty) ...{
            'name': name.trim(),
            'first_name': name.trim(),
          },
          'role': 'student',
        },
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

  static const _courseSelect =
      '*, teacher:profiles(*), overview_videos:course_overview_videos(*), '
      'lessons:lessons(*, resources:lesson_resources(*))';

  Future<List<CourseData>> fetchCourses() async {
    final res = await _client
        .from('courses')
        .select(_courseSelect)
        .eq('active', true)
        .order('created_at', ascending: false);

    try {
      final access = await fetchMyAccessProfile();
      _syncAccessProfileToController(access);
    } catch (_) {}

    return (res as List)
        .map((row) => _courseFromRow(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<CourseData>> searchCourses(String query) async {
    final q = query.trim();

    if (q.isEmpty) {
      final res = await _client
          .from('courses')
          .select(_courseSelect)
          .eq('active', true)
          .order('created_at', ascending: false)
          .limit(12);
      return (res as List)
          .map((row) => _courseFromRow(row as Map<String, dynamic>))
          .toList();
    }

    final byTextRes = await _client
        .from('courses')
        .select(_courseSelect)
        .eq('active', true)
        .or('title.ilike.%$q%,description.ilike.%$q%')
        .order('created_at', ascending: false)
        .limit(30);

    final byText = (byTextRes as List)
        .map((row) => _courseFromRow(row as Map<String, dynamic>))
        .toList();

    // Also include courses by matched teacher names.
    final teacherRes = await _client
        .from('profiles')
        .select('id')
        .eq('role', 'teacher')
        .or('first_name.ilike.%$q%,last_name.ilike.%$q%')
        .limit(30);
    final teacherIds = (teacherRes as List)
        .map((e) => (e as Map<String, dynamic>)['id']?.toString())
        .whereType<String>()
        .toList();

    List<CourseData> byTeacher = [];
    if (teacherIds.isNotEmpty) {
      final byTeacherRes = await _client
          .from('courses')
          .select(_courseSelect)
          .eq('active', true)
          .inFilter('teacher_id', teacherIds)
          .order('created_at', ascending: false)
          .limit(30);
      byTeacher = (byTeacherRes as List)
          .map(
            (row) => _courseFromRow(row as Map<String, dynamic>),
          )
          .toList();
    }

    final map = <String, CourseData>{};
    for (final c in [...byText, ...byTeacher]) {
      final id = c.id ?? '${c.title}-${c.description}';
      map[id] = c;
    }
    return map.values.toList();
  }

  CourseData _courseFromRow(Map<String, dynamic> row) {
    final teacher = row['teacher'];
    final lessonsList = row['lessons'] as List<dynamic>?;
    final overviewVideosList = row['overview_videos'] as List<dynamic>?;
    return CourseData(
      id: row['id']?.toString(),
      title: row['title'] as String?,
      teacher: teacher != null
          ? _profileToRegisterData(teacher as Map<String, dynamic>)
          : null,
      description: row['description'] as String?,
      learningObjectives: row['learning_objectives'] as String?,
      courseCover: row['course_cover_url'] as String?,
      overviewVideos: overviewVideosList
          ?.map((e) => _overviewVideoFromRow(e as Map<String, dynamic>))
          .toList()
        ?..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0)),
      lessons: () {
        final rawLessons =
            lessonsList?.cast<Map<String, dynamic>>() ?? const [];
        final sorted = List<Map<String, dynamic>>.from(rawLessons)
          ..sort(
            (a, b) => ((a['sort_order'] as int?) ?? 0)
                .compareTo((b['sort_order'] as int?) ?? 0),
          );
        return sorted.map(_lessonFromRow).toList();
      }(),
    );
  }

  CourseOverviewVideoData _overviewVideoFromRow(Map<String, dynamic> row) {
    return CourseOverviewVideoData(
      id: row['id']?.toString(),
      title: row['title'] as String?,
      url: row['url'] as String?,
      sortOrder: row['sort_order'] as int?,
    );
  }

  LessonData _lessonFromRow(Map<String, dynamic> row) {
    final resourcesList = row['resources'] as List<dynamic>?;
    return LessonData(
      id: row['id']?.toString(),
      course: row['course_id']?.toString(),
      title: row['title'] as String?,
      description: row['description'] as String?,
      file: row['file_url'] as String?,
      resources: resourcesList
          ?.map((e) => _lessonResourceFromRow(e as Map<String, dynamic>))
          .toList()
        ?..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0)),
    );
  }

  LessonResourceData _lessonResourceFromRow(Map<String, dynamic> row) {
    return LessonResourceData(
      id: row['id']?.toString(),
      lessonId: row['lesson_id']?.toString(),
      resourceType: row['resource_type'] as String?,
      title: row['title'] as String?,
      url: row['url'] as String?,
      sourceKind: row['source_kind'] as String?,
      sortOrder: row['sort_order'] as int?,
    );
  }

  Future<List<CourseCommentData>> fetchCourseComments(String courseId) async {
    final res = await _client
        .from('course_comments')
        .select('id, course_id, user_id, content, created_at, updated_at')
        .eq('course_id', courseId)
        .order('created_at', ascending: true);

    final comments = (res as List)
        .map((row) => row as Map<String, dynamic>)
        .toList();
    if (comments.isEmpty) return const [];

    final userIds = comments
        .map((c) => c['user_id']?.toString())
        .whereType<String>()
        .toSet()
        .toList();

    final profilesRes = await _client
        .from('profiles')
        .select('id, first_name, last_name, email, role')
        .inFilter('id', userIds);

    final profileById = <String, Map<String, dynamic>>{};
    for (final p in profilesRes as List) {
      final map = p as Map<String, dynamic>;
      final id = map['id']?.toString();
      if (id != null) profileById[id] = map;
    }

    return comments.map((c) {
      final userId = c['user_id']?.toString();
      final profile = userId != null ? profileById[userId] : null;
      final first = profile?['first_name']?.toString().trim() ?? '';
      final last = profile?['last_name']?.toString().trim() ?? '';
      final email = profile?['email']?.toString().trim() ?? '';
      final authorName = '$first $last'.trim();
      return CourseCommentData(
        id: c['id']?.toString(),
        courseId: c['course_id']?.toString(),
        userId: userId,
        content: c['content'] as String?,
        createdAt: c['created_at']?.toString(),
        updatedAt: c['updated_at']?.toString(),
        authorName: authorName.isNotEmpty ? authorName : email,
        authorRole: profile?['role']?.toString(),
      );
    }).toList();
  }

  Future<CourseCommentData?> postCourseComment(
    String courseId,
    String content,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final trimmed = content.trim();
    if (trimmed.isEmpty) return null;

    final res = await _client
        .from('course_comments')
        .insert({
          'course_id': courseId,
          'user_id': userId,
          'content': trimmed,
        })
        .select('id, course_id, user_id, content, created_at, updated_at')
        .single();

    final row = res;
    final profile = await _client
        .from('profiles')
        .select('first_name, last_name, email, role')
        .eq('id', userId)
        .maybeSingle();

    final first = profile?['first_name']?.toString().trim() ?? '';
    final last = profile?['last_name']?.toString().trim() ?? '';
    final email = profile?['email']?.toString().trim() ?? '';
    final authorName = '$first $last'.trim();

    return CourseCommentData(
      id: row['id']?.toString(),
      courseId: row['course_id']?.toString(),
      userId: row['user_id']?.toString(),
      content: row['content'] as String?,
      createdAt: row['created_at']?.toString(),
      updatedAt: row['updated_at']?.toString(),
      authorName: authorName.isNotEmpty ? authorName : email,
      authorRole: profile?['role']?.toString(),
    );
  }

  RegisterData _profileToRegisterData(Map<String, dynamic> p) {
    return RegisterData(
      id: p['id']?.toString(),
      email: p['email'] as String?,
      firstName: p['first_name'] as String?,
      lastName: p['last_name'] as String?,
      phone: p['phone']?.toString(),
      vocation: p['vocation']?.toString(),
      testimony: p['testimony']?.toString(),
      journey: p['journey']?.toString(),
      pImage: p['avatar_url'] as String?,
      role: p['role'] as String?,
    );
  }

  // ---------------------------------------------------------------------------
  // Books (library)
  // ---------------------------------------------------------------------------

  Future<List<LibraryData>> fetchBooks() async {
    try {
      final access = await fetchMyAccessProfile();
      _syncAccessProfileToController(access);
    } catch (_) {}

    final res = await _client
        .from('books')
        .select()
        .order('created_at', ascending: false);
    return (res as List)
        .map((row) => _bookFromRow(row as Map<String, dynamic>))
        .toList();
  }

  void _syncAccessProfileToController(Map<String, dynamic> access) {
    try {
      Get.find<DataController>().setAccessProfile(
        role: access['role'] ?? '',
      );
    } catch (_) {
      // Ignore if controller isn't ready (e.g. in tests).
    }
  }

  Future<Map<String, dynamic>> fetchMyAccessProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return {'role': ''};
    }
    final row = await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();
    return {'role': row?['role']?.toString() ?? ''};
  }

  Future<List<BookType>> fetchBookCategories() async {
    final res = await _client.rpc(
      'get_enum_values',
      params: {'enum_name': 'book_category'},
    );

    final categories = <BookType>[];
    for (final item in (res as List)) {
      if (item is Map<String, dynamic>) {
        final value = (item['value'] ?? '').toString().trim();
        if (value.isNotEmpty) {
          categories.add(_bookTypeFromRaw(value));
        }
      } else {
        final value = item.toString().trim();
        if (value.isNotEmpty) {
          categories.add(_bookTypeFromRaw(value));
        }
      }
    }
    final unique = categories.toSet().toList();
    developer.log(
      'book_category enum values: ${unique.map((e) => e.name).toList()}',
      name: 'SupabaseService',
    );
    return unique;
  }

  Future<List<LibraryData>> searchBooks(String query) async {
    final q = query.trim();
    final request = _client.from('books').select();
    final res = q.isEmpty
        ? await request.order('created_at', ascending: false).limit(20)
        : await request
            .or('title.ilike.%$q%,author.ilike.%$q%,description.ilike.%$q%')
            .order('created_at', ascending: false)
            .limit(30);

    return (res as List)
        .map((row) => _bookFromRow(row as Map<String, dynamic>))
        .toList();
  }

  String? _bookFileUrlFromRow(Map<String, dynamic> row) {
    final raw = (row['book_file_url'] ?? row['book_url'])?.toString().trim();
    if (raw == null || raw.isEmpty) return null;
    return raw;
  }

  LibraryData _bookFromRow(Map<String, dynamic> row) {
    final category = _bookTypeFromRaw(row['category'] as String?);
    return LibraryData(
      id: row['id']?.toString(),
      title: row['title'] as String?,
      author: row['author'] as String?,
      book: _bookFileUrlFromRow(row),
      category: category,
      bookCover: row['book_cover_url'] as String?,
      description: row['description'] as String?,
      language: row['language'] as String?,
    );
  }

  BookType _bookTypeFromRaw(String? raw) {
    switch ((raw ?? '').trim()) {
      case 'bible':
        return BookType.bible;
      case 'commentary':
        return BookType.commentary;
      case 'dictionnaire':
        return BookType.dictionnaire;
      case 'concordance':
        return BookType.concordance;
      default:
        return BookType.other;
    }
  }

  @visibleForTesting
  BookType mapBookTypeFromRawForTest(String? raw) => _bookTypeFromRaw(raw);

  @visibleForTesting
  LibraryData mapBookFromRowForTest(Map<String, dynamic> row) =>
      _bookFromRow(row);

  // ---------------------------------------------------------------------------
  // Assignments (course/lesson + student submission + MCQ auto-grading)
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchPublishedAssignmentsForCourse(
      String courseId) async {
    final res = await _client
        .from('assignments')
        .select(
          'id,title,description,pdf_url,published,due_date,lesson_id,lesson:lessons(id,title),created_at',
        )
        .eq('course_id', courseId)
        .eq('published', true)
        .order('created_at', ascending: false);

    return (res as List).map((row) {
      final m = row as Map<String, dynamic>;
      return {
        ...m,
        'lesson_title': (m['lesson']?['title'] as String?),
      };
    }).toList();
  }

  Future<Map<String, dynamic>> fetchAssignmentDetails(
      String assignmentId) async {
    final assignmentRes = await _client
        .from('assignments')
        .select('id,title,description,pdf_url,due_date,lesson_id')
        .eq('id', assignmentId)
        .maybeSingle();

    final assignment = assignmentRes as Map<String, dynamic>;

    final questionsRes = await _client
        .from('assignment_questions')
        .select('id,type,prompt,order_index,points')
        .eq('assignment_id', assignmentId)
        .order('order_index');

    final questions = (questionsRes as List).map((qRow) {
      final q = qRow as Map<String, dynamic>;
      final type = (q['type'] ?? '').toString();
      return <String, dynamic>{
        'id': q['id']?.toString(),
        'type': type,
        'prompt': q['prompt'] as String?,
        'order_index': q['order_index'],
        'points': (q['points'] as num?)?.toDouble(),
        'options': <Map<String, dynamic>>[],
      };
    }).toList();

    final mcqQuestionIds = questions
        .where((q) => (q['type'] as String?) == 'mcq_single')
        .map((q) => q['id'] as String)
        .toList();

    if (mcqQuestionIds.isNotEmpty) {
      final optionsRes = await _client
          .from('assignment_mcq_options')
          .select('id,question_id,option_text,order_index')
          .inFilter('question_id', mcqQuestionIds)
          .order('order_index');

      final optionRows = (optionsRes as List).cast<Map<String, dynamic>>();

      final byQuestionId = <String, List<Map<String, dynamic>>>{};
      for (final o in optionRows) {
        final qid = o['question_id']?.toString();
        if (qid == null) continue;
        byQuestionId.putIfAbsent(qid, () => <Map<String, dynamic>>[]);
        byQuestionId[qid]!.add({
          'id': o['id']?.toString(),
          'question_id': qid,
          'option_text': o['option_text'] as String?,
          'order_index': o['order_index'],
        });
      }

      for (final q in questions) {
        final qid = q['id'] as String?;
        if (qid == null) continue;
        if (byQuestionId.containsKey(qid)) {
          q['options'] = byQuestionId[qid]!;
        }
      }
    }

    return {
      'assignment': assignment,
      'questions': questions,
    };
  }

  Future<Map<String, dynamic>?> fetchMySubmissionForAssignment(
      String assignmentId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final submissionRes = await _client
        .from('assignment_submissions')
        .select(
          'id,submitted_at,mcq_score_total,open_score_total,final_score_total',
        )
        .eq('assignment_id', assignmentId)
        .eq('student_id', userId)
        .maybeSingle();

    if (submissionRes == null) return null;

    final submission = Map<String, dynamic>.from(submissionRes);
    final submissionId = submission['id']?.toString();
    if (submissionId == null) return submission;

    final answersRes = await _client
        .from('assignment_submission_answers')
        .select(
          'question_id,selected_option_id,student_answer_pdf_url,teacher_points,teacher_feedback,mcq_points_awarded,mcq_is_correct',
        )
        .eq('submission_id', submissionId);

    final answersRows =
        (answersRes as List).cast<Map<String, dynamic>>();

    final answersByQuestionId = <String, Map<String, dynamic>>{};
    for (final a in answersRows) {
      final qid = a['question_id']?.toString();
      if (qid == null) continue;
      answersByQuestionId[qid] = a;
    }

    submission['answers_by_question_id'] = answersByQuestionId;
    return submission;
  }

  Future<void> submitAssignment({
    required String assignmentId,
    required List<Map<String, dynamic>> questions,
    required Map<String, String?> selectedOptionByQuestionId,
    required Map<String, File?> openPdfByQuestionId,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Insert submission first so we can build student answer storage paths.
    final submissionRes = await _client
        .from('assignment_submissions')
        .insert({
          'assignment_id': assignmentId,
          'student_id': userId,
        })
        .select('id')
        .maybeSingle();

    if (submissionRes == null) {
      throw Exception('Failed to create submission');
    }

    final submissionId = submissionRes['id']?.toString();
    if (submissionId == null) {
      throw Exception('Missing submission id');
    }

    // Upload/open answer PDFs (optional) and insert per-question answer rows.
    for (final q in questions) {
      final qid = q['id']?.toString();
      if (qid == null) continue;
      final type = (q['type'] ?? '').toString();

      if (type == 'mcq_single') {
        final selectedOptionId = selectedOptionByQuestionId[qid];
        await _client.from('assignment_submission_answers').insert({
          'submission_id': submissionId,
          'question_id': qid,
          'selected_option_id': selectedOptionId,
          'student_answer_pdf_url': null,
        });
      } else if (type == 'open_pdf' || type == 'open_doc') {
        final file = openPdfByQuestionId[qid];
        String? publicUrl;

        if (file != null) {
          final ext = file.path.split('.').last.toLowerCase();
          final fileName =
              '${DateTime.now().microsecondsSinceEpoch}.$ext';
          final storagePath = '$submissionId/$qid/$fileName';
          final contentType = type == 'open_doc'
              ? (ext == 'docx'
                  ? 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                  : ext == 'odt'
                      ? 'application/vnd.oasis.opendocument.text'
                      : 'application/msword')
              : 'application/pdf';

          await _client.storage.from('assignment-submissions').upload(
                storagePath,
                file,
                fileOptions: FileOptions(contentType: contentType),
              );

          publicUrl = _client.storage
              .from('assignment-submissions')
              .getPublicUrl(storagePath);
        }

        await _client.from('assignment_submission_answers').insert({
          'submission_id': submissionId,
          'question_id': qid,
          'selected_option_id': null,
          'student_answer_pdf_url': publicUrl,
        });
      } else {
        throw Exception('Unknown question type: $type');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Announcements / notifications
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchVisibleAnnouncements({
    int limit = 50,
  }) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();
    final res = await _client
        .from('announcements')
        .select('id,title,body,visible_until,created_at,course_id,course:courses(id,title)')
        .eq('published', true)
        .gte('visible_until', nowIso)
        .order('created_at', ascending: false)
        .limit(limit);

    return (res as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>?> fetchLatestAnnouncement() async {
    final rows = await fetchVisibleAnnouncements(limit: 1);
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<List<String>> fetchReadAnnouncementIds(List<String> announcementIds) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || announcementIds.isEmpty) return const [];

    final res = await _client
        .from('announcement_reads')
        .select('announcement_id')
        .eq('student_id', userId)
        .inFilter('announcement_id', announcementIds);

    return (res as List)
        .map((e) => (e as Map<String, dynamic>)['announcement_id']?.toString())
        .whereType<String>()
        .toList();
  }

  Future<int> fetchUnreadAnnouncementsCount() async {
    final announcements = await fetchVisibleAnnouncements(limit: 100);
    if (announcements.isEmpty) return 0;
    final ids = announcements
        .map((a) => a['id']?.toString())
        .whereType<String>()
        .toList();
    final readIds = await fetchReadAnnouncementIds(ids);
    return ids.where((id) => !readIds.contains(id)).length;
  }

  Future<void> markAnnouncementAsRead(String announcementId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    await _client.from('announcement_reads').upsert(
      {
        'announcement_id': announcementId,
        'student_id': userId,
        'read_at': DateTime.now().toUtc().toIso8601String(),
      },
      onConflict: 'announcement_id,student_id',
    );
  }

  Future<void> markAnnouncementsAsRead(List<String> announcementIds) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || announcementIds.isEmpty) return;

    final payload = announcementIds
        .map(
          (id) => {
            'announcement_id': id,
            'student_id': userId,
            'read_at': DateTime.now().toUtc().toIso8601String(),
          },
        )
        .toList();

    await _client
        .from('announcement_reads')
        .upsert(payload, onConflict: 'announcement_id,student_id');
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

  Future<String?> fetchProfileLastNameByEmail(String email) async {
    final normalized = email.trim();
    if (normalized.isEmpty) return null;
    try {
      final row = await _client
          .from('profiles')
          .select('last_name')
          .eq('email', normalized)
          .maybeSingle();
      if (row is! Map<String, dynamic>) return null;
      final value = (row['last_name'] ?? '').toString().trim();
      return value.isEmpty ? null : value;
    } catch (_) {
      return null;
    }
  }

  Future<List<RegisterData>> searchTeachers(String query) async {
    final q = query.trim();
    final request = _client.from('profiles').select().eq('role', 'teacher');
    final res = q.isEmpty
        ? await request.order('created_at', ascending: false).limit(20)
        : await request
            .or('first_name.ilike.%$q%,last_name.ilike.%$q%,email.ilike.%$q%')
            .order('created_at', ascending: false)
            .limit(30);

    return (res as List)
        .map((e) => _profileToRegisterData(e as Map<String, dynamic>))
        .toList();
  }

  String? _whatsappFromProfileRow(Map<String, dynamic> row) {
    const keys = <String>[
      'whatsapp_number',
      'whatsapp',
      'phone_number',
      'phone',
      'mobile',
      'telephone',
    ];
    for (final key in keys) {
      final raw = row[key];
      if (raw == null) continue;
      final value = raw.toString().trim();
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  Future<String?> fetchTeacherWhatsAppNumber(String teacherId) async {
    final id = teacherId.trim();
    if (id.isEmpty) return null;
    try {
      final row =
          await _client.from('profiles').select().eq('id', id).maybeSingle();
      if (row is! Map<String, dynamic>) return null;
      return _whatsappFromProfileRow(row);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Rooms (forum groups)
  // ---------------------------------------------------------------------------

  /// Finds the forum room linked to a course (matched by course title).
  Future<GroupData?> fetchGroupForCourse({
    required String courseTitle,
  }) async {
    final title = courseTitle.trim();
    if (title.isEmpty) return null;

    try {
      final res = await _client
          .from('rooms')
          .select()
          .eq('is_deleted', false)
          .eq('name', title)
          .maybeSingle();

      if (res is! Map<String, dynamic>) return null;

      final id = res['id']?.toString();
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
      return _groupFromRow(res, participantsCount: count);
    } catch (_) {
      return null;
    }
  }

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

  Future<Uint8List> fetchRemoteFileBytes(String url) async {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      headers: const {'Accept': '*/*'},
    ));

    final response = await dio.get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    final data = response.data;
    if (data == null || data.isEmpty) {
      throw const FormatException('Empty file received');
    }

    return Uint8List.fromList(data);
  }

  Future<Uint8List> fetchPdfBytes(String url) async {
    final bytes = await fetchRemoteFileBytes(url);
    final isPdf = bytes.length >= 4 &&
        bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46;
    if (!isPdf) {
      throw const FormatException('Invalid PDF data');
    }
    return bytes;
  }

  Future<File> fetchPdfData(String url) async {
    final bytes = await fetchRemoteFileBytes(url);
    final dir = Directory.systemTemp;
    final filePath =
        '${dir.path}/downloaded_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
