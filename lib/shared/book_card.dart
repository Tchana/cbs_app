import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.bookImage, required this.title});
  final String? bookImage, title;

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
              color: Colors.red,
            ),
            gapH8,
            Text(
              title!,
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
