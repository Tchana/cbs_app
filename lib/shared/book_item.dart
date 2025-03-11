import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/utils/constants/colors.dart';
import 'package:center_for_biblical_studies/utils/constants/text_styles.dart';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final LibraryData book;
  final void Function()? onPressed;

  const BookItem({
    super.key,
    required this.book,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title!.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: largeBodyStyle.copyWith(color: CustomColors.black),
                  ),
                  Text(
                    book.description ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        mediumBodyStyle.copyWith(color: CustomColors.darkGrey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(book.language ?? "ENG"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
