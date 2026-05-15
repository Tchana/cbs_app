import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final LibraryData book;
  final void Function()? onPressed;
  final bool isLocked;

  const BookItem({
    super.key,
    required this.book,
    this.onPressed,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final title = (book.title ?? '').trim();
    final author = (book.author ?? '').trim();
    final hasCover = (book.bookCover ?? '').trim().isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final cardColor = isDark ? CbsColors.darkSurface : CbsColors.white;
    final titleColor = isDark ? CbsColors.darkText : CbsColors.primaryDark[800];
    final subtitleColor = isDark ? CbsColors.darkHint : CbsColors.hintColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardColor,
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
              if (isLocked)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline,
                          size: 14, color: CbsColors.errorColor),
                      const SizedBox(width: 4),
                      Text(
                        l10n.locked,
                        style: verySmallStyle12.copyWith(
                          color: CbsColors.errorColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                title.isEmpty ? '—' : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: smallStyle18.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                author.isEmpty ? l10n.authorUnknown : l10n.authorPrefix(author),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: smallStyle18.copyWith(
                  color: subtitleColor,
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
