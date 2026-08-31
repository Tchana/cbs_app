import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:center_for_biblical_studies/shared/cached_remote_image.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.courseData,
    this.onPressed,
  });

  final CourseData courseData;
  final VoidCallback? onPressed;

  String get _teacherName {
    final t = courseData.teacher;
    if (t == null) return '';
    return '${t.firstName ?? ''} ${t.lastName ?? ''}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));

    if (Adaptive.isDesktop(context)) {
      return _DesktopCourseCard(
        courseData: courseData,
        onPressed: onPressed,
        teacherName: _teacherName,
        l10n: l10n,
      );
    }

    return _MobileCourseCard(
      courseData: courseData,
      onPressed: onPressed,
      teacherName: _teacherName,
    );
  }
}

class _DesktopCourseCard extends StatelessWidget {
  const _DesktopCourseCard({
    required this.courseData,
    required this.onPressed,
    required this.teacherName,
    required this.l10n,
  });

  static const _coverHeight = 84.0;
  static const _titleFontSize = 17.0;
  static const _titleLineHeight = 1.3;
  static const _titleLines = 2;
  static const _teacherRowHeight = 20.0;
  static const _lessonsRowHeight = 18.0;
  static const _buttonHeight = 38.0;

  final CourseData courseData;
  final VoidCallback? onPressed;
  final String teacherName;
  final AppLocalizations l10n;

  double get _titleBlockHeight =>
      _titleFontSize * _titleLineHeight * _titleLines;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coverUrl = (courseData.courseCover ?? '').trim();
    final title = (courseData.title ?? '').trim();
    final lessonCount = courseData.lessons?.length ?? 0;
    final lessonsText =
        lessonCount > 0 ? '$lessonCount ${l10n.lessonsLabel}' : '';

    final bg = isDark ? CbsColors.darkSurface : Colors.white;
    final border = isDark
        ? CbsColors.goldDeep.withValues(alpha: 0.22)
        : CbsColors.creamDark;
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : const Color(0xFF2A1608);
    final subtitleColor =
        isDark ? CbsColors.darkTextSecondary : CbsColors.hintColor;

    return Material(
      color: bg,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _coverHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _CourseCoverBanner(
                    coverUrl: coverUrl,
                    isDark: isDark,
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.school_rounded,
                            size: 13,
                            color: CbsColors.brandGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.navCourses,
                            style: verySmallStyle10.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 36,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: _titleBlockHeight,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title.isNotEmpty ? title : l10n.courseDefault,
                        maxLines: _titleLines,
                        overflow: TextOverflow.ellipsis,
                        style: smallStyle18.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: _titleFontSize,
                          height: _titleLineHeight,
                          color: titleColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: _teacherRowHeight,
                    child: teacherName.isEmpty
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 15,
                                color: isDark
                                    ? CbsColors.brandGold
                                    : CbsColors.primaryBrown,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  teacherName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: smallStyle18.copyWith(
                                    fontSize: 14,
                                    height: 1.2,
                                    color: subtitleColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: _lessonsRowHeight,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        lessonsText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: smallStyle18.copyWith(
                          fontSize: 13,
                          height: 1.2,
                          color: subtitleColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: _buttonHeight,
                    child: FilledButton(
                      onPressed: onPressed,
                      style: FilledButton.styleFrom(
                        backgroundColor: isDark
                            ? CbsColors.brandGold
                            : CbsColors.primaryBrown,
                        foregroundColor: isDark
                            ? const Color(0xFF2A1608)
                            : Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Text(
                        l10n.view,
                        style: smallStyle18.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCoverBanner extends StatelessWidget {
  const _CourseCoverBanner({
    required this.coverUrl,
    required this.isDark,
  });

  final String coverUrl;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (coverUrl.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF3A2210), const Color(0xFF1A1008)]
                : [const Color(0xFF8B5A2B), const Color(0xFF5C3D1E)],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.menu_book_rounded,
            size: 42,
            color: Colors.white.withValues(alpha: 0.82),
          ),
        ),
      );
    }

    return CachedRemoteImage(
      url: coverUrl,
      fit: BoxFit.cover,
      error: _CoverFallback(isDark: isDark),
      placeholder: ColoredBox(
        color: isDark ? CbsColors.darkElevated : CbsColors.goldPale,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
            ),
          ),
        ),
      ),
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF3A2210), const Color(0xFF1A1008)]
              : [const Color(0xFF8B5A2B), const Color(0xFF5C3D1E)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 42,
          color: Colors.white.withValues(alpha: 0.82),
        ),
      ),
    );
  }
}

class _MobileCourseCard extends StatelessWidget {
  const _MobileCourseCard({
    required this.courseData,
    required this.onPressed,
    required this.teacherName,
  });

  final CourseData courseData;
  final VoidCallback? onPressed;
  final String teacherName;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? CbsColors.darkSurface : CbsColors.white;
    final border = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.primaryBrown.withValues(alpha: 0.2);
    final iconBg = isDark
        ? CbsColors.darkElevated
        : CbsColors.primaryBrown.withValues(alpha: 0.12);
    final iconColor = isDark ? CbsColors.brandGold : CbsColors.primaryBrown;
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : CbsColors.primaryDark[800];
    final subtitleColor =
        isDark ? CbsColors.darkTextMetadata : CbsColors.hintColor;
    final chevronColor = isDark
        ? CbsColors.brandGold.withValues(alpha: 0.85)
        : CbsColors.hintColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: iconBg,
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 26,
                      color: iconColor,
                    ),
                  ),
                  gapW12,
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courseData.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: smallStyle18.copyWith(
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                            fontSize: 15,
                          ),
                        ),
                        if (teacherName.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            teacherName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: verySmallStyle12.copyWith(
                              color: subtitleColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: chevronColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
