import 'package:center_for_biblical_studies/data/authentication/register_data.dart';
import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/shared/custom_button.dart';
import 'package:center_for_biblical_studies/shared/section_header.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/constants/text_styles.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:center_for_biblical_studies/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DataController dataController = Get.find<DataController>();
  final SupabaseService apiService = SupabaseService();
  bool _loading = false;

  Future<void> fetchData() async {
    setState(() => _loading = true);
    try {
      final courses = await apiService.fetchCourses();
      dataController.setCourses(courses);
    } catch (_) {}
    try {
      final books = await apiService.fetchBooks();
      dataController.setBooks(books);
    } catch (_) {}
    try {
      final teachers = await apiService.fetchTeachers();
      dataController.setTeachers(teachers);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    if (dataController.courses.isEmpty &&
        dataController.books.isEmpty &&
        dataController.teachers.isEmpty) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final user = AuthService.currentUser;
    final meta = user?.userMetadata ?? {};
    final firstName = meta['first_name']?.toString().trim();
    final lastName = meta['last_name']?.toString().trim();
    final nameFromMeta = meta['name']?.toString().trim();
    final displayName = (firstName != null && lastName != null)
        ? '$firstName $lastName'.trim()
        : (firstName ??
            lastName ??
            nameFromMeta ??
            user?.email?.split('@').first ??
            '—');
    final displayEmail = user?.email ?? '';

    return Scaffold(
      backgroundColor: CbsColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchData,
          color: CbsColors.primaryBrown,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: avatar + greeting + actions
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            CbsColors.primaryBrown.withValues(alpha: 0.15),
                        child: Icon(
                          Icons.person_rounded,
                          size: 32,
                          color: CbsColors.primaryBrown,
                        ),
                      ),
                      gapW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: mediumStyle24Medium.copyWith(
                                color: CbsColors.primaryDark[800],
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            gapH4,
                            Text(
                              displayEmail,
                              style: verySmallStyle12.copyWith(
                                color: CbsColors.hintColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: CbsColors.primaryDark[500],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bookmark_border_rounded,
                          color: CbsColors.primaryDark[500],
                        ),
                      ),
                    ],
                  ),
                  gapH20,

                  // Search
                  TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      hintStyle: smallStyle18.copyWith(
                        color: CbsColors.hintColor,
                      ),
                      filled: true,
                      fillColor: CbsColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: CbsColors.primaryBrown.withValues(alpha: 0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: CbsColors.primaryBrown.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: CbsColors.primaryBrown,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      suffixIcon: Icon(
                        Icons.search_rounded,
                        color: CbsColors.primaryBrown,
                        size: 22,
                      ),
                    ),
                  ),
                  gapH24,

                  // Welcome card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: CbsColors.primaryBrown,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: CbsColors.primaryBrown.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color:
                                CbsColors.primaryYellow.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.play_circle_filled_rounded,
                            size: 44,
                            color: CbsColors.primaryYellow,
                          ),
                        ),
                        gapW16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.dashboardWelcome,
                                style: smallStyle18.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: CbsColors.white,
                                ),
                              ),
                              gapH8,
                              Text(
                                l10n.dashboardWelcomeSubtitle,
                                style: verySmallStyle12.copyWith(
                                  color: CbsColors.primaryYellow,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH28,

                  // Teachers section
                  SectionHeader(
                    title: l10n.teachersSection,
                    moreText: l10n.seeAll,
                  ),
                  gapH12,
                  _loading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: CbsColors.primaryBrown,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 200,
                          child: Obx(() {
                            final teachers = dataController.teachers;
                            if (teachers.isEmpty) {
                              return Center(
                                child: Text(
                                  l10n.loading,
                                  style: smallStyle18.copyWith(
                                    color: CbsColors.hintColor,
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: teachers.take(5).length,
                              separatorBuilder: (_, __) => gapW16,
                              itemBuilder: (_, i) => _TeacherCard(
                                teacher: teachers[i],
                                onContact: () =>
                                    checkWhatsAppAndCall('+237656388275'),
                                contactLabel: l10n.contact,
                              ),
                            );
                          }),
                        ),
                  gapH28,

                  // Courses section
                  SectionHeader(
                    title: l10n.coursesSection,
                    moreText: l10n.seeAll,
                  ),
                  gapH12,
                  _loading
                      ? const SizedBox.shrink()
                      : Obx(() {
                          final courses = dataController.courses;
                          if (courses.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  l10n.loading,
                                  style: smallStyle18.copyWith(
                                    color: CbsColors.hintColor,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: courses
                                .take(5)
                                .map((course) => CourseCard(courseData: course))
                                .toList(),
                          );
                        }),
                  gapH16,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({
    required this.teacher,
    required this.onContact,
    required this.contactLabel,
  });

  final RegisterData teacher;
  final VoidCallback onContact;
  final String contactLabel;

  @override
  Widget build(BuildContext context) {
    final name = '${teacher.firstName ?? ''} ${teacher.lastName ?? ''}'.trim();
    final hasImage =
        teacher.pImage != null && teacher.pImage!.trim().isNotEmpty;

    return SizedBox(
      width: 140,
      child: Material(
        color: CbsColors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        shadowColor: CbsColors.primaryDark[800]?.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: CbsColors.primaryBrown.withValues(alpha: 0.1),
                backgroundImage:
                    hasImage ? NetworkImage(teacher.pImage!) : null,
                child: hasImage
                    ? null
                    : Icon(
                        Icons.person_rounded,
                        size: 36,
                        color: CbsColors.primaryBrown.withValues(alpha: 0.6),
                      ),
              ),
              gapH10,
              Text(
                name.isEmpty ? '—' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: mediumBodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CbsColors.primaryDark[800],
                ),
              ),
              gapH4,
              Text(
                teacher.email ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: smallBodyStyle.copyWith(
                  color: CbsColors.hintColor,
                  fontSize: 12,
                ),
              ),
              gapH10,
              CbsButton(
                width: double.infinity,
                height: 32,
                bgColor: CbsColors.primaryBrown,
                onPressed: onContact,
                child: Text(
                  contactLabel,
                  style: verySmallStyle10.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CbsColors.white,
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
