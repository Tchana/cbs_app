import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/features/courses/lesson_page.dart';
import 'package:center_for_biblical_studies/services/authentication.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/shared/page_header.dart';
import 'package:center_for_biblical_studies/shared/tab_button.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
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

  final ApiService apiService = ApiService();
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
    print(dataController.courses);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: IndexedStack(
          index: _widgetIndex,
          children: [
            Column(
              children: [
                gapH16,
                PageHeader(
                  title: 'Cours',
                  titleIcon: const Icon(
                    Icons.school_outlined,
                    color: CbsColors.primaryBlue,
                  ),
                ),
                gapH32,
                Theme(
                  data: ThemeData(),
                  child: TabBar(
                    dividerHeight: 0,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: CbsColors.primaryBlue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    unselectedLabelColor: CbsColors.primaryBlue,
                    labelColor: CbsColors.white,
                    tabs: [
                      Tab(
                        child: TabButton(label: "Tout"),
                      ),
                      Tab(
                        child: TabButton(label: "En cours"),
                      ),
                      Tab(
                        child: TabButton(label: "Terminé"),
                      ),
                    ],
                  ),
                ),
                gapH10,
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
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
            ),
          ],
        ),
      ),
    );
  }
}
