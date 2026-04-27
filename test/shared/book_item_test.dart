import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/shared/book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BookItem shows title and author prefix', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 300,
            child: BookItem(
              book: const LibraryData(
                title: 'Romans',
                author: 'Paul',
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Romans'), findsOneWidget);
    expect(find.text('Author: Paul'), findsOneWidget);
  });

  testWidgets('BookItem calls callback on tap', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            height: 300,
            child: BookItem(
              book: const LibraryData(title: 'Genesis'),
              onPressed: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(BookItem));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
