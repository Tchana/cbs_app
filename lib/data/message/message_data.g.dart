// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageData _$MessageDataFromJson(Map<String, dynamic> json) => _MessageData(
      uuid: json['uuid'] as String?,
      room: json['room'] as String?,
      user: json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String?,
      timestamp: json['timestamp'] as String?,
      message_type: json['message_type'] as String?,
      is_deleted: json['is_deleted'] as bool?,
      deleted_at: json['deleted_at'] as String?,
    );

Map<String, dynamic> _$MessageDataToJson(_MessageData instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'room': instance.room,
      'user': instance.user,
      'content': instance.content,
      'timestamp': instance.timestamp,
      'message_type': instance.message_type,
      'is_deleted': instance.is_deleted,
      'deleted_at': instance.deleted_at,
    };
