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
      book: json['book'] as String?,
      category: $enumDecodeNullable(_$BookTypeEnumMap, json['category']),
      bookCover: json['bookCover'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
    );

Map<String, dynamic> _$$LibraryDataImplToJson(_$LibraryDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'book': instance.book,
      'category': _$BookTypeEnumMap[instance.category],
      'bookCover': instance.bookCover,
      'description': instance.description,
      'language': instance.language,
    };

const _$BookTypeEnumMap = {
  BookType.bible: 'bible',
  BookType.commentary: 'commentary',
  BookType.concordance: 'concordance',
  BookType.other: 'other',
};
