import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/features/courses/lesson_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/shared/page_header.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  void _nextPage() {
    setState(() {
      _widgetIndex++;
    });
  }

  void fetchData() async {
    final dataController = Get.find<DataController>();

    try {
      final courses = await apiService.fetchCourses();
      print("List of courses: $courses");
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
    print(dataController.courses);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: IndexedStack(
            index: _widgetIndex,
            children: [
              Column(
                children: [
                  gapH16,
                  PageHeader(
                    title: l10n.navCourses,
                    titleIcon: const Icon(
                      Icons.school_outlined,
                      color: CbsColors.primaryBrown,
                    ),
                  ),
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
                              onPressed: () {
                                setState(() {
                                  selectedCourse = course;
                                });
                                _nextPage();
                              },
                            );
                          }).toList(),
                        ),
                        ListView(
                          children: dataController.courses.map((course) {
                            return CourseCard(courseData: course);
                          }).toList(),
                        ),
                        ListView(
                          children: dataController.courses.map((course) {
                            return CourseCard(courseData: course);
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
  }
}
