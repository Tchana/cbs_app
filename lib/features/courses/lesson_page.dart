import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/features/assignments/course_assignments_page.dart';
import 'package:center_for_biblical_studies/shared/open_remote_file.dart';
import 'package:center_for_biblical_studies/shared/remote_file_kind.dart';
import 'package:center_for_biblical_studies/shared/remote_file_icons.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/subscribe_bottom_sheet.dart';
import 'package:center_for_biblical_studies/shared/custom_button.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonPage extends StatefulWidget {
  final CourseData? courseData;
  final VoidCallback? onBack;

  const LessonPage({
    super.key,
    this.courseData,
    this.onBack,
  });

  static String _teacherDisplayName(RegisterData? teacher) {
    if (teacher == null) return '—';
    final name = '${teacher.firstName ?? ''} ${teacher.lastName ?? ''}'.trim();
    return name.isEmpty ? '—' : name;
  }

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final SupabaseService _apiService = SupabaseService();
  late CourseData? _courseData = widget.courseData;

  Future<void> _showSubscribeDialog() async {
    await showSubscribeBottomSheet(
      context: context,
      api: _apiService,
      onActivated: () {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final description = (_courseData?.description ?? '').trim();
    final lessonCount = _courseData?.lessons?.length ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CbsColors.darkCard : CbsColors.white;
    final titleColor = isDark ? CbsColors.darkText : CbsColors.primaryDark[800];
    final bodyColor = isDark ? CbsColors.darkHint : CbsColors.primaryDark[500];
    final dc = Get.find<DataController>();
    final canAccessLessons = dc.canAccessCourseLevel(_courseData?.level);
    final canSubmitAssignments = dc.canSubmitAssignments;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          // Course info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description.isNotEmpty) ...[
                  Text(
                    l10n.descriptionLabel,
                    style: smallStyle18.copyWith(
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  gapH8,
                  Text(
                    description,
                    style: verySmallStyle12.copyWith(
                      color: bodyColor,
                      height: 1.4,
                    ),
                  ),
                  gapH16,
                ],
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.person_outline_rounded,
                      label: l10n.teacherLabel,
                      value:
                          LessonPage._teacherDisplayName(_courseData?.teacher),
                    ),
                    const SizedBox(width: 16),
                    _InfoChip(
                      icon: Icons.menu_book_rounded,
                      label: l10n.lessonsLabel,
                      value: '$lessonCount',
                    ),
                  ],
                ),
              ],
            ),
          ),
          gapH24,

          // Lessons section
          Text(
            l10n.lessonsLabel,
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          gapH12,
          if (lessonCount == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 48,
                      color: CbsColors.primaryBrown.withValues(alpha: 0.4),
                    ),
                    gapH12,
                    Text(
                      l10n.noLessonsYet,
                      style: verySmallStyle14.copyWith(
                        color: CbsColors.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(lessonCount, (index) {
              final lesson = _courseData?.lessons?[index];
              return lesson != null
                  ? _LessonCard(
                      index: index,
                      lesson: lesson,
                      l10n: l10n,
                      onTap: () {
                        if (!canAccessLessons) {
                          _showSubscribeDialog();
                          return;
                        }
                        final url = lesson.file?.trim() ?? '';
                        if (url.isNotEmpty) {
                          openRemoteFile(url, title: lesson.title);
                        }
                      },
                      isLockedByAccess: !canAccessLessons,
                    )
                  : const SizedBox.shrink();
            }),
          gapH24,

          // Assignments section
          Text(
            l10n.assignmentsTitle,
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          gapH12,
          if (canAccessLessons)
            CbsButton(
              width: double.infinity,
              height: 50,
              bgColor: CbsColors.primaryBrown,
              borderColor: CbsColors.primaryBrown,
              onPressed: () {
                final courseId = _courseData?.id;
                if (courseId == null) return;
                Get.to(() => CourseAssignmentsPage(courseId: courseId));
              },
              child: Text(
                l10n.viewAssignments,
                style: verySmallStyle12.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            Text(
              l10n.locked,
              style: verySmallStyle12.copyWith(
                color: CbsColors.hintColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (canAccessLessons && !canSubmitAssignments) ...[
            gapH8,
            Text(
              l10n.subscriptionRequiredNoAccess,
              style: verySmallStyle12.copyWith(
                color: CbsColors.hintColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: CbsColors.primaryBrown.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: CbsColors.primaryBrown),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: verySmallStyle10.copyWith(
                      color: CbsColors.hintColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: verySmallStyle12.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CbsColors.primaryDark[800],
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

class _LessonCard extends StatelessWidget {
  final int index;
  final LessonData lesson;
  final AppLocalizations l10n;
  final VoidCallback? onTap;
  final bool isLockedByAccess;

  const _LessonCard({
    required this.index,
    required this.lesson,
    required this.l10n,
    this.onTap,
    this.isLockedByAccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final fileUrl = (lesson.file ?? '').trim();
    final hasFile = fileUrl.isNotEmpty && !isLockedByAccess;
    final fileKind = hasFile ? remoteFileKindFromUrl(fileUrl) : RemoteFileKind.external;
    final rawTitle = (lesson.title ?? '').trim();
    final displayTitle = rawTitle.isEmpty
        ? '${l10n.lessonLabel} ${index + 1}'
        : '${l10n.lessonLabel} ${index + 1}: $rawTitle';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: hasFile ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: CbsColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CbsColors.primaryBrown.withValues(alpha: 0.18),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CbsColors.primaryBrown.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: hasFile
                        ? Icon(
                            iconForRemoteFileKind(fileKind),
                            size: 22,
                            color: CbsColors.primaryBrown,
                          )
                        : Icon(
                            Icons.lock_outline_rounded,
                            size: 20,
                            color: CbsColors.hintColor,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: verySmallStyle14.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CbsColors.primaryDark[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasFile
                            ? l10n.openFile
                            : (isLockedByAccess ? l10n.locked : l10n.notAvailable),
                        style: verySmallStyle12.copyWith(
                          color: hasFile
                              ? CbsColors.primaryBrown
                              : CbsColors.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  hasFile ? Icons.chevron_right_rounded : Icons.lock_rounded,
                  size: 22,
                  color: hasFile ? CbsColors.primaryBrown : CbsColors.hintColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
