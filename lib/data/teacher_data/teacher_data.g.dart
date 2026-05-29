// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherData _$TeacherDataFromJson(Map<String, dynamic> json) => _TeacherData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profileImage: json['profileImage'] == null
          ? null
          : ProfileImage.fromJson(json['profileImage'] as Map<String, dynamic>),
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => CourseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeacherDataToJson(_TeacherData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'profileImage': instance.profileImage,
      'courses': instance.courses,
    };

_ProfileImage _$ProfileImageFromJson(Map<String, dynamic> json) =>
    _ProfileImage(
      id: json['id'] as String?,
      url: json['url'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$ProfileImageToJson(_ProfileImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'text': instance.text,
    };
