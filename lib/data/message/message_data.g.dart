// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageDataImpl _$$MessageDataImplFromJson(Map<String, dynamic> json) =>
    _$MessageDataImpl(
      uuid: json['uuid'] as String?,
      room: json['room'] as String?,
      content: json['content'] as String?,
      created_at: json['created_at'] as String?,
      created_by: json['created_by'] as String?,
      sender_name: json['sender_name'] as String?,
      sender_email: json['sender_email'] as String?,
      is_deleted: json['is_deleted'] as bool?,
      deleted_at: json['deleted_at'] as String?,
      deleted_by: json['deleted_by'] as String?,
    );

Map<String, dynamic> _$$MessageDataImplToJson(_$MessageDataImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'room': instance.room,
      'content': instance.content,
      'created_at': instance.created_at,
      'created_by': instance.created_by,
      'sender_name': instance.sender_name,
      'sender_email': instance.sender_email,
      'is_deleted': instance.is_deleted,
      'deleted_at': instance.deleted_at,
      'deleted_by': instance.deleted_by,
    };
