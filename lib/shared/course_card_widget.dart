import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final CourseData courseData;
  final void Function()? onPressed;
  final bool isEnrolled;

  const CourseCard({
    super.key,
    required this.courseData,
    this.onPressed,
    this.isEnrolled = false,
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
    final l10n = AppLocalizations.of(context);
    final registerLabel = l10n?.register ?? 'Register';
    final enrolledLabel = l10n?.enrolled ?? 'Enrolled';
    final ctaLabel = isEnrolled ? enrolledLabel : registerLabel;
    final hasLevel = _levelLabel.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
          decoration: BoxDecoration(
            color: CbsColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CbsColors.primaryBrown.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
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
                  color: CbsColors.primaryBrown.withValues(alpha: 0.12),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 26,
                  color: CbsColors.primaryBrown,
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
                        color: CbsColors.primaryDark[800],
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
                          color: CbsColors.hintColor,
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
                              color: CbsColors.primaryBrown.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _levelLabel,
                              style: verySmallStyle10.copyWith(
                                fontWeight: FontWeight.w600,
                                color: CbsColors.primaryBrown,
                              ),
                            ),
                          ),
                        if (hasLevel) const SizedBox(width: 8),
                        Text(
                          ctaLabel,
                          style: verySmallStyle12.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isEnrolled
                                ? CbsColors.successColor
                                : CbsColors.primaryBrown,
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
                color: CbsColors.hintColor,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
