import 'package:center_for_biblical_studies/data/library/library_data.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

/// Normalizes book language from API/backoffice to a short EN / FR label.
String? bookLanguageBadgeLabel(String? language, AppLocalizations l10n) =>
    l10n.bookLanguageBadge(language);

class BookItem extends StatelessWidget {
  final LibraryData book;
  final void Function()? onPressed;
  final bool isLocked;
  final bool compact;
  final bool coverOnRight;

  const BookItem({
    super.key,
    required this.book,
    this.onPressed,
    this.isLocked = false,
    this.compact = false,
    this.coverOnRight = false,
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
    final borderColor = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.primaryBrown.withValues(alpha: 0.14);
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : CbsColors.primaryDark[800];
    final subtitleColor =
        isDark ? CbsColors.darkTextMetadata : CbsColors.hintColor;
    final languageLabel = bookLanguageBadgeLabel(book.language, l10n);

    final radius = compact ? 10.0 : 14.0;
    final coverRadius = compact ? 8.0 : 10.0;
    final padding = compact ? 6.0 : 10.0;
    final titleSize = compact ? 11.0 : 14.0;
    final authorSize = compact ? 9.0 : 12.0;
    final titleGap = compact ? 6.0 : 10.0;

    final cover = _BookCover(
      hasCover: hasCover,
      coverUrl: book.bookCover,
      coverRadius: coverRadius,
      compact: compact,
      languageLabel: languageLabel,
      isDark: isDark,
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          coverOnRight ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (isLocked)
          Padding(
            padding: EdgeInsets.only(bottom: compact ? 4 : 8),
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
        Text(
          title.isEmpty ? l10n.dash : title,
          maxLines: coverOnRight ? 2 : 1,
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
    );

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
              color: borderColor,
            ),
          ),
          child: coverOnRight
              ? Row(
                  children: [
                    Expanded(child: details),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 72,
                      height: 102,
                      child: cover,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cover),
                    SizedBox(height: titleGap),
                    details,
                  ],
                ),
        ),
      ),
    );
  }

}

class _BookCover extends StatelessWidget {
  const _BookCover({
    required this.hasCover,
    required this.coverUrl,
    required this.coverRadius,
    required this.compact,
    required this.languageLabel,
    required this.isDark,
    this.fit = BoxFit.cover,
    this.expand = true,
    this.height,
  });

  final bool hasCover;
  final String? coverUrl;
  final double coverRadius;
  final bool compact;
  final String? languageLabel;
  final bool isDark;
  final BoxFit fit;
  final bool expand;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final image = hasCover
        ? Image.network(
            coverUrl!,
            height: expand ? null : height,
            fit: fit,
            errorBuilder: (_, __, ___) => _coverFallback(compact),
          )
        : SizedBox(
            height: height,
            width: height == null ? null : height! * 2 / 3,
            child: _coverFallback(compact),
          );

    return Container(
      width: expand ? double.infinity : null,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? CbsColors.darkElevated
            : CbsColors.primaryBrown.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(coverRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: expand ? StackFit.expand : StackFit.loose,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(coverRadius),
            child: image,
          ),
          if (languageLabel != null)
            Positioned(
              top: compact ? 4 : 6,
              right: compact ? 4 : 6,
              child: _LanguageBadge(
                label: languageLabel!,
                compact: compact,
              ),
            ),
        ],
      ),
    );
  }

  Widget _coverFallback(bool compact) {
    return Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: compact ? 18 : 24,
        color: CbsColors.brandGold.withValues(alpha: compact ? 0.85 : 0.75),
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
        color: CbsColors.brandGold,
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
          color: CbsColors.brownNight,
          fontWeight: FontWeight.w800,
          fontSize: compact ? 8 : 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Home recent-book card: title, author, and View on the left; cover on the right.
class HomeBookCard extends StatelessWidget {
  const HomeBookCard({
    super.key,
    required this.book,
    required this.onView,
  });

  final LibraryData book;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = (book.title ?? '').trim();
    final author = (book.author ?? '').trim();
    final hasCover = (book.bookCover ?? '').trim().isNotEmpty;
    final languageLabel = bookLanguageBadgeLabel(book.language, l10n);
    final bg = isDark ? CbsColors.darkSurface : const Color(0xFFFBF7F1);
    final border = isDark
        ? CbsColors.brandGold.withValues(alpha: 0.38)
        : CbsColors.primaryBrown.withValues(alpha: 0.22);
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : const Color(0xFF2A1608);
    final authorColor =
        isDark ? CbsColors.darkTextMetadata : CbsColors.hintColor;

    return Container(
      height: 122,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? l10n.dash : title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: smallStyle18.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  author.isEmpty
                      ? l10n.authorUnknown
                      : l10n.authorPrefix(author),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: smallStyle18.copyWith(
                    color: authorColor,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: onView,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                    foregroundColor:
                        isDark ? const Color(0xFF2A1608) : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    minimumSize: const Size(96, 34),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    l10n.view,
                    style: smallStyle18.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _BookCover(
              hasCover: hasCover,
              coverUrl: book.bookCover,
              coverRadius: 10,
              compact: false,
              languageLabel: languageLabel,
              isDark: isDark,
              fit: BoxFit.fitHeight,
              expand: false,
              height: 102,
            ),
          ),
        ],
      ),
    );
  }
}
