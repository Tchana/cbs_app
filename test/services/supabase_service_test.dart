import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = SupabaseService.testable();

  test('mapBookTypeFromRawForTest maps enum values correctly', () {
    expect(service.mapBookTypeFromRawForTest('bible'), BookType.bible);
    expect(
      service.mapBookTypeFromRawForTest('commentary'),
      BookType.commentary,
    );
    expect(
      service.mapBookTypeFromRawForTest('dictionnaire'),
      BookType.dictionnaire,
    );
    expect(
      service.mapBookTypeFromRawForTest('concordance'),
      BookType.concordance,
    );
    expect(service.mapBookTypeFromRawForTest('other'), BookType.other);
    expect(service.mapBookTypeFromRawForTest('unknown'), BookType.other);
  });

  test('mapBookFromRowForTest maps book row payload to LibraryData', () {
    final book = service.mapBookFromRowForTest({
      'id': 'b1',
      'title': 'Romans',
      'author': 'Paul',
      'book_url': 'https://example.com/romans.pdf',
      'category': 'commentary',
      'book_cover_url': 'https://example.com/romans.jpg',
      'description': 'A commentary',
      'language': 'en',
    });

    expect(book.id, 'b1');
    expect(book.title, 'Romans');
    expect(book.author, 'Paul');
    expect(book.book, 'https://example.com/romans.pdf');
    expect(book.category, BookType.commentary);
    expect(book.bookCover, 'https://example.com/romans.jpg');
    expect(book.description, 'A commentary');
    expect(book.language, 'en');
  });
}
