// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TeacherData _$$_TeacherDataFromJson(Map<String, dynamic> json) =>
    _$_TeacherData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      profileImage: json['profileImage'] == null
          ? null
          : ProfileImage.fromJson(json['profileImage'] as Map<String, dynamic>),
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => CourseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_TeacherDataToJson(_$_TeacherData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileImage': instance.profileImage,
      'courses': instance.courses,
    };

_$_ProfileImage _$$_ProfileImageFromJson(Map<String, dynamic> json) =>
    _$_ProfileImage(
      id: json['id'] as String?,
      url: json['url'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$_ProfileImageToJson(_$_ProfileImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'text': instance.text,
    };
