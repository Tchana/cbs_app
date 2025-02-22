// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeacherDataImpl _$$TeacherDataImplFromJson(Map<String, dynamic> json) =>
    _$TeacherDataImpl(
      id: json['id'] as String?,
      name: json['name'] as String?,
      profileImage: json['profileImage'] == null
          ? null
          : ProfileImage.fromJson(json['profileImage'] as Map<String, dynamic>),
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => CourseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TeacherDataImplToJson(_$TeacherDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileImage': instance.profileImage,
      'courses': instance.courses,
    };

_$ProfileImageImpl _$$ProfileImageImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImageImpl(
      id: json['id'] as String?,
      url: json['url'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$ProfileImageImplToJson(_$ProfileImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'text': instance.text,
    };
