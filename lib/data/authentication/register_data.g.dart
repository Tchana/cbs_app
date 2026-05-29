// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterData _$RegisterDataFromJson(Map<String, dynamic> json) =>
    _RegisterData(
      id: json['id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      vocation: json['vocation'] as String?,
      testimony: json['testimony'] as String?,
      journey: json['journey'] as String?,
      pImage: json['pImage'] as String?,
      role: json['role'] as String?,
      course: (json['course'] as List<dynamic>?)
          ?.map((e) => CourseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RegisterDataToJson(_RegisterData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'vocation': instance.vocation,
      'testimony': instance.testimony,
      'journey': instance.journey,
      'pImage': instance.pImage,
      'role': instance.role,
      'course': instance.course,
    };
