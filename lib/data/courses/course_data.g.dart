// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseDataImpl _$$CourseDataImplFromJson(Map<String, dynamic> json) =>
    _$CourseDataImpl(
      id: json['id'] as String?,
      title: json['title'] as String?,
      teacher: json['teacher'] == null
          ? null
          : RegisterData.fromJson(json['teacher'] as Map<String, dynamic>),
      description: json['description'] as String?,
      level: json['level'] as String?,
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => LessonData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CourseDataImplToJson(_$CourseDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'teacher': instance.teacher,
      'description': instance.description,
      'level': instance.level,
      'lessons': instance.lessons,
    };

_$LessonDataImpl _$$LessonDataImplFromJson(Map<String, dynamic> json) =>
    _$LessonDataImpl(
      id: json['id'] as String?,
      course: json['course'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      file: json['file'] as String?,
    );

Map<String, dynamic> _$$LessonDataImplToJson(_$LessonDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course': instance.course,
      'title': instance.title,
      'description': instance.description,
      'file': instance.file,
    };
