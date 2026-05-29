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
      level: json['level'] as String?,
      isEnrolled: json['isEnrolled'] as bool?,
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
      'level': instance.level,
      'isEnrolled': instance.isEnrolled,
      'lessons': instance.lessons,
    };

_LessonData _$LessonDataFromJson(Map<String, dynamic> json) => _LessonData(
      id: json['id'] as String?,
      course: json['course'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      file: json['file'] as String?,
    );

Map<String, dynamic> _$LessonDataToJson(_LessonData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course': instance.course,
      'title': instance.title,
      'description': instance.description,
      'file': instance.file,
    };
