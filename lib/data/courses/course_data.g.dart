// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CourseData _$CourseDataFromJson(Map<String, dynamic> json) => _CourseData(
      id: json['id'] as String?,
      title: json['title'] as String?,
      teacher: json['teacher'] == null
          ? null
          : RegisterData.fromJson(json['teacher'] as Map<String, dynamic>),
      description: json['description'] as String?,
      learningObjectives: json['learning_objectives'] as String?,
      courseCover: json['courseCover'] as String?,
      isEnrolled: json['isEnrolled'] as bool?,
      overviewVideos: (json['overview_videos'] as List<dynamic>?)
          ?.map((e) =>
              CourseOverviewVideoData.fromJson(e as Map<String, dynamic>))
          .toList(),
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => LessonData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CourseDataToJson(_CourseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'teacher': instance.teacher,
      'description': instance.description,
      'learning_objectives': instance.learningObjectives,
      'courseCover': instance.courseCover,
      'isEnrolled': instance.isEnrolled,
      'overview_videos': instance.overviewVideos,
      'lessons': instance.lessons,
    };

_CourseOverviewVideoData _$CourseOverviewVideoDataFromJson(
        Map<String, dynamic> json) =>
    _CourseOverviewVideoData(
      id: json['id'] as String?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CourseOverviewVideoDataToJson(
        _CourseOverviewVideoData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'sort_order': instance.sortOrder,
    };

_LessonData _$LessonDataFromJson(Map<String, dynamic> json) => _LessonData(
      id: json['id'] as String?,
      course: json['course'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      file: json['file'] as String?,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => LessonResourceData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LessonDataToJson(_LessonData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course': instance.course,
      'title': instance.title,
      'description': instance.description,
      'file': instance.file,
      'resources': instance.resources,
    };

_LessonResourceData _$LessonResourceDataFromJson(Map<String, dynamic> json) =>
    _LessonResourceData(
      id: json['id'] as String?,
      lessonId: json['lesson_id'] as String?,
      resourceType: json['resource_type'] as String?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      sourceKind: json['source_kind'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LessonResourceDataToJson(_LessonResourceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lesson_id': instance.lessonId,
      'resource_type': instance.resourceType,
      'title': instance.title,
      'url': instance.url,
      'source_kind': instance.sourceKind,
      'sort_order': instance.sortOrder,
    };

_CourseCommentData _$CourseCommentDataFromJson(Map<String, dynamic> json) =>
    _CourseCommentData(
      id: json['id'] as String?,
      courseId: json['course_id'] as String?,
      userId: json['user_id'] as String?,
      content: json['content'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      authorName: json['authorName'] as String?,
      authorRole: json['authorRole'] as String?,
    );

Map<String, dynamic> _$CourseCommentDataToJson(_CourseCommentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_id': instance.courseId,
      'user_id': instance.userId,
      'content': instance.content,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'authorName': instance.authorName,
      'authorRole': instance.authorRole,
    };
