import 'package:center_for_biblical_studies/services/book_file_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stableRemoteKey uses storage object path not signed query', () {
    const unsigned =
        'https://project.supabase.co/storage/v1/object/public/books/folder/book.docx';
    const signed =
        'https://project.supabase.co/storage/v1/object/sign/books/folder/book.docx?token=abc';

    expect(BookFileCacheService.stableRemoteKey(unsigned), 'books/folder/book.docx');
    expect(BookFileCacheService.stableRemoteKey(signed), 'books/folder/book.docx');
  });

  test('stableRemoteKey falls back to URI path', () {
    expect(
      BookFileCacheService.stableRemoteKey('https://cdn.example.com/files/a.pdf'),
      '/files/a.pdf',
    );
  });
}
