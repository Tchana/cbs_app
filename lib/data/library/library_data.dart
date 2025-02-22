import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_data.freezed.dart';
part 'library_data.g.dart';

enum BookType {
  bible,
  commentary,
  concordance,
  other,
}

@freezed
class LibraryData with _$LibraryData {
  const LibraryData._();

  const factory LibraryData({
    String? id,
    String? title,
    String? author,
    BookType? type,
  }) = _LibraryData;

  factory LibraryData.fromJson(Map<String, dynamic> json) =>
      _$LibraryDataFromJson(json);
}
