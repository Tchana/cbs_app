// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LibraryDataImpl _$$LibraryDataImplFromJson(Map<String, dynamic> json) =>
    _$LibraryDataImpl(
      id: json['id'] as String?,
      title: json['title'] as String?,
      author: json['author'] as String?,
      type: $enumDecodeNullable(_$BookTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$LibraryDataImplToJson(_$LibraryDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'type': _$BookTypeEnumMap[instance.type],
    };

const _$BookTypeEnumMap = {
  BookType.bible: 'bible',
  BookType.commentary: 'commentary',
  BookType.concordance: 'concordance',
  BookType.other: 'other',
};
