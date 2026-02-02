import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book});
  final LibraryData book;

  @override
  Widget build(BuildContext context) {
    final hasCover =
        book.bookCover != null && book.bookCover!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 140,
              width: 100,
              decoration: BoxDecoration(
                color: CbsColors.primaryBrown.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: CbsColors.primaryDark.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: hasCover
                    ? Image.network(
                        book.bookCover!,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 140,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
            gapH10,
            Text(
              book.title ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: smallStyle18.copyWith(
                color: CbsColors.primaryDark[800],
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: 40,
        color: CbsColors.primaryBrown.withValues(alpha: 0.5),
      ),
    );
  }
}
