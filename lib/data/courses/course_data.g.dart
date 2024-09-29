// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CourseData _$$_CourseDataFromJson(Map<String, dynamic> json) =>
    _$_CourseData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => LessonData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_CourseDataToJson(_$_CourseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lessons': instance.lessons,
    };

_$_LessonData _$$_LessonDataFromJson(Map<String, dynamic> json) =>
    _$_LessonData(
      id: json['id'] as String?,
      title: json['title'] as String?,
      duration: json['duration'] as int?,
    );

Map<String, dynamic> _$$_LessonDataToJson(_$_LessonData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'duration': instance.duration,
    };
