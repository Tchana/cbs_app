// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      uuid: json['uuid'] as String?,
      firstName: json['firstName'] as String?,
      email: json['email'] as String?,
      lastName: json['lastName'] as String?,
      bio: json['bio'] as String?,
      online_status: json['online_status'] as bool?,
      last_seen: json['last_seen'] as String?,
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'firstName': instance.firstName,
      'email': instance.email,
      'lastName': instance.lastName,
      'bio': instance.bio,
      'online_status': instance.online_status,
      'last_seen': instance.last_seen,
    };
