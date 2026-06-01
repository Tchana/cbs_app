import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/services/book_reading_progress_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('reading progress percentage follows current page over total pages', () {
    const currentPage = 7;
    const totalPages = 20;
    final progress = (currentPage / totalPages).clamp(0.0, 1.0);
    expect(progress, closeTo(0.35, 0.001));
    expect((progress * 100).round(), 35);
  });

  test('resolveContinueReading returns the most recently opened book', () async {
    final service = BookReadingProgressService();
    const books = [
      LibraryData(id: 'a', title: 'Book A'),
      LibraryData(id: 'b', title: 'Book B'),
    ];

    await service.recordPageProgress(
      bookId: 'a',
      currentPage: 40,
      totalPages: 100,
    );
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await service.markLastOpened('b');

    final entry = await service.resolveContinueReading(books);
    expect(entry?.book.id, 'b');
  });

  test('resolveContinueReading skips 100% book for next most recent', () async {
    final service = BookReadingProgressService();
    const books = [
      LibraryData(id: 'done', title: 'Finished'),
      LibraryData(id: 'active', title: 'In progress'),
    ];

    await service.recordPageProgress(
      bookId: 'active',
      currentPage: 10,
      totalPages: 100,
    );
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await service.recordPageProgress(
      bookId: 'done',
      currentPage: 50,
      totalPages: 50,
    );

    final entry = await service.resolveContinueReading(books);
    expect(entry?.book.id, 'active');
  });

  test('markLastOpened updates timestamp when reopening another book', () async {
    final service = BookReadingProgressService();
    const books = [
      LibraryData(id: 'a', title: 'Book A'),
      LibraryData(id: 'b', title: 'Book B'),
    ];

    await service.markLastOpened('a');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await service.markLastOpened('b');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await service.markLastOpened('a');

    final entry = await service.resolveContinueReading(books);
    expect(entry?.book.id, 'a');
  });
}
