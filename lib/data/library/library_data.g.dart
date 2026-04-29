part of 'library_data.dart';

BookType? _bookTypeFromJson(dynamic raw) {
  final v = raw?.toString().trim();
  switch (v) {
    case 'bible':
      return BookType.bible;
    case 'commentary':
      return BookType.commentary;
    case 'dictionnaire':
      return BookType.dictionnaire;
    case 'concordance':
      return BookType.concordance;
    case 'other':
      return BookType.other;
    default:
      return null;
  }
}

String? _bookTypeToJson(BookType? type) {
  return type?.name;
}

_LibraryData _$LibraryDataFromJson(Map<String, dynamic> json) => _LibraryData(
      id: json['id'] as String?,
      title: json['title'] as String?,
      author: json['author'] as String?,
      book: json['book'] as String?,
      category: _bookTypeFromJson(json['category']),
      bookCover: json['bookCover'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
    );

Map<String, dynamic> _$LibraryDataToJson(_LibraryData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'book': instance.book,
      'category': _bookTypeToJson(instance.category),
      'bookCover': instance.bookCover,
      'description': instance.description,
      'language': instance.language,
    };

