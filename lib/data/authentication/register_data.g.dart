// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterDataImpl _$$RegisterDataImplFromJson(Map<String, dynamic> json) =>
    _$RegisterDataImpl(
      id: json['id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      p_image: json['p_image'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$$RegisterDataImplToJson(_$RegisterDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'p_image': instance.p_image,
      'role': instance.role,
    };
