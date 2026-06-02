import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final CourseData courseData;
  final void Function()? onPressed;

  const CourseCard({
    super.key,
    required this.courseData,
    this.onPressed,
  });

  String get _teacherName {
    final t = courseData.teacher;
    if (t == null) return '';
    final name = '${t.firstName ?? ''} ${t.lastName ?? ''}'.trim();
    return name;
  }

  String get _levelLabel {
    final level = courseData.level?.toLowerCase();
    if (level == null || level.isEmpty) return '';
    return level[0].toUpperCase() + level.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final hasLevel = _levelLabel.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? CbsColors.darkSurface : CbsColors.white;
    final border = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.primaryBrown.withValues(alpha: 0.2);
    final iconBg =
        isDark ? CbsColors.darkElevated : CbsColors.primaryBrown.withValues(alpha: 0.12);
    final iconColor = isDark ? CbsColors.brandGold : CbsColors.primaryBrown;
    final titleColor = isDark ? CbsColors.darkTextPrimary : CbsColors.primaryDark[800];
    final subtitleColor = isDark ? CbsColors.darkTextMetadata : CbsColors.hintColor;
    final chevronColor = isDark ? CbsColors.brandGold.withValues(alpha: 0.85) : CbsColors.hintColor;

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
            border: Border.all(
              color: border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Compact icon block
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
                    if (_teacherName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        _teacherName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: verySmallStyle12.copyWith(
                          color: subtitleColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (hasLevel)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? CbsColors.darkElevated
                                  : CbsColors.primaryBrown.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: isDark
                                  ? Border.all(
                                      color: CbsColors.goldDeep
                                          .withValues(alpha: 0.7),
                                    )
                                  : null,
                            ),
                            child: Text(
                              _levelLabel,
                              style: verySmallStyle10.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? CbsColors.brandGold
                                    : CbsColors.primaryBrown,
                              ),
                            ),
                          ),
                      ],
                    ),
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
    );
  }
}
