import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      book.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: smallStyle18.copyWith(
                        color: CbsColors.primaryDark[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if ((book.description ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        book.description ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: smallStyle18.copyWith(
                          color: CbsColors.hintColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CbsColors.primaryBrown.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  book.language ?? 'ENG',
                  style: smallStyle18.copyWith(
                    color: CbsColors.primaryBrown,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
