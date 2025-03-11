import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book});
  final LibraryData book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        height: 120,
        width: 70,
        child: Column(
          children: [
            Container(
              height: 95,
              width: 70,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(book.bookCover ?? ""),
                      fit: BoxFit.cover)),
            ),
            gapH8,
            Text(
              book.title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            gapH8,
          ],
        ),
      ),
    );
  }
}
