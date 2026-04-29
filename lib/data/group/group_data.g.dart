part of 'group_data.dart';

_GroupData _$GroupDataFromJson(Map<String, dynamic> json) => _GroupData(
      uuid: json['uuid'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      created_at: json['created_at'] as String?,
      created_by: json['created_by'] as String?,
      is_private: json['is_private'] as bool?,
      is_deleted: json['is_deleted'] as bool?,
      deleted_at: json['deleted_at'] as String?,
      deleted_by: json['deleted_by'] as String?,
      participants_count: json['participants_count'] as int?,
      online_count: json['online_count'] as int?,
      can_delete: json['can_delete'] as bool?,
    );

Map<String, dynamic> _$GroupDataToJson(_GroupData instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'description': instance.description,
      'created_at': instance.created_at,
      'created_by': instance.created_by,
      'is_private': instance.is_private,
      'is_deleted': instance.is_deleted,
      'deleted_at': instance.deleted_at,
      'deleted_by': instance.deleted_by,
      'participants_count': instance.participants_count,
      'online_count': instance.online_count,
      'can_delete': instance.can_delete,
    };

