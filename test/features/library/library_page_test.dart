import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/features/library/Library_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeLibrarySupabaseService extends SupabaseService {
  const _FakeLibrarySupabaseService();

  @override
  Future<List<BookType>> fetchBookCategories() async {
    return const [BookType.bible, BookType.commentary, BookType.other];
  }

  @override
  Future<List<LibraryData>> fetchBooks() async {
    return const [
      LibraryData(
        id: '1',
        title: 'Genesis',
        author: 'Moses',
        category: BookType.bible,
      ),
      LibraryData(
        id: '2',
        title: 'Commentary A',
        author: 'John',
        category: BookType.commentary,
      ),
    ];
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('LibraryPage renders fetched tabs and continue reading',
      (tester) async {
    final dc = Get.put(DataController());
    // Library UI access is subscription-driven; enable it for this widget test.
    dc.setAccessProfile(role: 'library_user');
    dc.setBooks(const [
      LibraryData(
        id: '1',
        title: 'Genesis',
        author: 'Moses',
        category: BookType.bible,
      ),
      LibraryData(
        id: '2',
        title: 'Commentary A',
        author: 'John',
        category: BookType.commentary,
      ),
    ]);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('fr')],
        home: MediaQuery(
          data: MediaQueryData(size: Size(390, 844)),
          child: LibraryPage(apiService: _FakeLibrarySupabaseService()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Bibles'), findsOneWidget);
    expect(find.text('Commentaries'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    expect(find.text('Genesis'), findsWidgets);
  });
}
