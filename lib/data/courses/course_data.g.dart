// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseDataImpl _$$CourseDataImplFromJson(Map<String, dynamic> json) =>
    _$CourseDataImpl(
      id: json['id'] as String?,
      title: json['title'] as String?,
      teacher: json['teacher'] as String?,
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
      title: json['title'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LessonDataImplToJson(_$LessonDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': instance.duration,
    };
