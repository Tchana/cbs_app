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
    final title = (book.title ?? '').trim();
    final author = (book.author ?? '').trim();
    final hasCover = (book.bookCover ?? '').trim().isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CbsColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: CbsColors.primaryBrown.withValues(alpha: 0.14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CbsColors.primaryBrown.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: hasCover
                          ? Image.network(
                              book.bookCover!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _coverFallback(),
                            )
                          : _coverFallback(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title.isEmpty ? '—' : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: smallStyle18.copyWith(
                  color: CbsColors.primaryDark[800],
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                author.isEmpty ? 'Author: —' : 'Author: $author',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: smallStyle18.copyWith(
                  color: CbsColors.hintColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverFallback() {
    return Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: 24,
        color: CbsColors.primaryBrown.withValues(alpha: 0.55),
      ),
    );
  }
}
