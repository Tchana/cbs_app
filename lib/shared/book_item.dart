import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

/// Normalizes book language from API/backoffice to a short EN / FR label.
String? bookLanguageBadgeLabel(String? language) {
  final raw = (language ?? '').trim().toLowerCase();
  if (raw.isEmpty) return null;
  if (raw == 'en' ||
      raw == 'english' ||
      raw == 'anglais' ||
      raw.startsWith('en')) {
    return 'EN';
  }
  if (raw == 'fr' ||
      raw == 'french' ||
      raw == 'français' ||
      raw == 'francais' ||
      raw.startsWith('fr')) {
    return 'FR';
  }
  return null;
}

class BookItem extends StatelessWidget {
  final LibraryData book;
  final void Function()? onPressed;
  final bool isLocked;
  final bool compact;

  const BookItem({
    super.key,
    required this.book,
    this.onPressed,
    this.isLocked = false,
    this.compact = false,
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
    final languageLabel = bookLanguageBadgeLabel(book.language);

    final radius = compact ? 10.0 : 14.0;
    final coverRadius = compact ? 8.0 : 10.0;
    final padding = compact ? 6.0 : 10.0;
    final titleSize = compact ? 11.0 : 14.0;
    final authorSize = compact ? 9.0 : 12.0;
    final titleGap = compact ? 6.0 : 10.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(radius),
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
                      borderRadius: BorderRadius.circular(coverRadius),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(coverRadius),
                          child: hasCover
                              ? Image.network(
                                  book.bookCover!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _coverFallback(compact),
                                )
                              : _coverFallback(compact),
                        ),
                        if (languageLabel != null)
                          Positioned(
                            top: compact ? 4 : 6,
                            right: compact ? 4 : 6,
                            child: _LanguageBadge(
                              label: languageLabel,
                              compact: compact,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLocked)
                Padding(
                  padding: EdgeInsets.only(top: compact ? 4 : 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: compact ? 11 : 14,
                        color: CbsColors.errorColor,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        l10n.locked,
                        style: verySmallStyle12.copyWith(
                          color: CbsColors.errorColor,
                          fontWeight: FontWeight.w700,
                          fontSize: compact ? 9 : 11,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: titleGap),
              Text(
                title.isEmpty ? '—' : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: smallStyle18.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w700,
                  fontSize: titleSize,
                ),
              ),
              SizedBox(height: compact ? 1 : 2),
              Text(
                author.isEmpty ? l10n.authorUnknown : l10n.authorPrefix(author),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: smallStyle18.copyWith(
                  color: subtitleColor,
                  fontSize: authorSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverFallback(bool compact) {
    return Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: compact ? 18 : 24,
        color: CbsColors.primaryBrown.withValues(alpha: 0.55),
      ),
    );
  }
}

class _LanguageBadge extends StatelessWidget {
  const _LanguageBadge({required this.label, this.compact = false});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 7,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: CbsColors.primaryBrown.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        label,
        style: verySmallStyle12.copyWith(
          color: CbsColors.white,
          fontWeight: FontWeight.w800,
          fontSize: compact ? 8 : 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
