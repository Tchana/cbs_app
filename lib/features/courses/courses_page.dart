import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/features/courses/lesson_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/services/recent_access_service.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:center_for_biblical_studies/shared/subscribe_bottom_sheet.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with TickerProviderStateMixin {
  final DataController dataController = Get.find<DataController>();

  final SupabaseService apiService = SupabaseService();
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  int _widgetIndex = 0;

  CourseData? selectedCourse;

  bool _isCourseEnrolled(CourseData course) {
    final id = course.id;
    if (id == null || id.isEmpty) return false;
    return dataController.isCourseEnrolled(id);
  }

  Future<void> _showSubscribeDialog() async {
    if (!mounted) return;
    await showSubscribeBottomSheet(
      context: context,
      api: apiService,
      onActivated: () async {
        await fetchData();
      },
    );
  }

  Future<void> fetchData() async {
    final dataController = Get.find<DataController>();

    try {
      final courses = await apiService.fetchCourses();
      dataController.setCourses(courses);
    } catch (e) {
      // Handle errors if needed
    }
  }

  @override
  initState() {
    if (dataController.courses.isEmpty) {
      fetchData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final sub = dataController.subscriptionType.value.trim();
      final hasCourses = dataController.hasCourseAccess;
      if (!hasCourses) {
        return Scaffold(
          backgroundColor:
              isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
          appBar: AppBar(
            title: Text(
              l10n.navCourses,
              style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
            ),
            centerTitle: false,
            actions: [
              TextButton.icon(
                onPressed: _showSubscribeDialog,
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: Text(l10n.subscribe),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 56,
                    color: CbsColors.primaryBrown.withValues(alpha: 0.6),
                  ),
                  gapH16,
                  Text(
                    l10n.subscriptionRequiredTitle,
                    textAlign: TextAlign.center,
                    style: smallStyle18.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  gapH8,
                  Text(
                    sub.isEmpty || sub == 'none'
                        ? l10n.subscriptionRequiredCourses
                        : l10n.subscriptionRequiredNoAccess,
                    textAlign: TextAlign.center,
                    style: smallStyle18.copyWith(
                      color: isDark ? CbsColors.darkHint : CbsColors.hintColor,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  gapH20,
                  FilledButton(
                    onPressed: _showSubscribeDialog,
                    style: FilledButton.styleFrom(
                      backgroundColor: CbsColors.primaryBrown,
                      foregroundColor: CbsColors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(l10n.subscribe),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
      backgroundColor:
          isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          _widgetIndex == 0
              ? l10n.navCourses
              : (selectedCourse?.title?.trim().isNotEmpty == true
                  ? selectedCourse!.title!
                  : l10n.courseDefault),
          style: smallStyle18.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        leading: _widgetIndex == 0
            ? null
            : IconButton(
                onPressed: () => setState(() => _widgetIndex = 0),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
        actions: _widgetIndex == 0
            ? [
                IconButton(
                  onPressed: fetchData,
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: l10n.refresh,
                ),
              ]
            : [
                TextButton.icon(
                  onPressed: _showSubscribeDialog,
                  icon: const Icon(Icons.school_outlined, size: 18),
                  label: Text(l10n.enroll),
                ),
              ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: IndexedStack(
            index: _widgetIndex,
            children: [
              Column(
                children: [
                  gapH16,
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: CbsColors.primaryBrown.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CbsColors.primaryBrown.withValues(alpha: 0.18),
                        width: 1,
                      ),
                    ),
                    child: TabBar(
                      tabAlignment: TabAlignment.fill,
                      dividerHeight: 0,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: CbsColors.primaryBrown,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color:
                                CbsColors.primaryBrown.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      labelColor: CbsColors.white,
                      unselectedLabelColor:
                          CbsColors.primaryBrown.withValues(alpha: 0.85),
                      labelStyle: smallStyle18.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      unselectedLabelStyle: smallStyle18.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: CbsColors.primaryBrown.withValues(alpha: 0.85),
                      ),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      padding: EdgeInsets.zero,
                      tabs: [
                        Tab(text: l10n.tabAll),
                        Tab(text: l10n.tabInProgress),
                        Tab(text: l10n.tabCompleted),
                      ],
                    ),
                  ),
                  gapH10,
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView(
                          children: dataController.courses.map((course) {
                            return CourseCard(
                              courseData: course,
                              isEnrolled: _isCourseEnrolled(course),
                              onPressed: () {
                                RecentAccessService.markCourseAccessed(course.id);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => _CourseDetailsPage(course: course),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        ListView(
                          children: dataController.courses.map((course) {
                            return CourseCard(
                              courseData: course,
                              isEnrolled: _isCourseEnrolled(course),
                              onPressed: () {
                                RecentAccessService.markCourseAccessed(course.id);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => _CourseDetailsPage(course: course),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        ListView(
                          children: dataController.courses.map((course) {
                            return CourseCard(
                              courseData: course,
                              isEnrolled: _isCourseEnrolled(course),
                              onPressed: () {
                                RecentAccessService.markCourseAccessed(course.id);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => _CourseDetailsPage(course: course),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  )
                ],
              ),
              LessonPage(
                courseData: selectedCourse,
                onBack: () => setState(() => _widgetIndex = 0),
              ),
            ],
          ),
        ),
      ),
    );
    });
  }
}

class _CourseDetailsPage extends StatelessWidget {
  const _CourseDetailsPage({required this.course});
  final CourseData course;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = (course.title ?? '').trim();
    return Scaffold(
      backgroundColor:
          isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          title.isNotEmpty ? title : l10n.courseDefault,
          style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: LessonPage(
            courseData: course,
          ),
        ),
      ),
    );
  }
}
