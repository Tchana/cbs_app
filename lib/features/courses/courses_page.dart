import 'package:center_for_biblical_studies/features/courses/lesson_page.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  int _widgetIndex = 0;

  void _nextPage() {
    setState(() {
      _widgetIndex++;
    });
  }

  void _prevPage() {
    setState(() {
      _widgetIndex--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: IndexedStack(
          index: _widgetIndex,
          children: [
            Column(
              children: [
                gapH16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          color: CbsColors.primaryBlue,
                        ),
                        gapW4,
                        Text(
                          "Cours",
                          style: normalStyle20.copyWith(
                              color: CbsColors.primaryBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.notifications_none_outlined,
                            color: CbsColors.primaryBlue,
                          ),
                        ),
                        gapW4,
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.bookmark_add_outlined,
                            color: CbsColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                gapH32,
                Theme(
                  data: ThemeData(),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: CbsColors.primaryBlue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    unselectedLabelColor: CbsColors.primaryBlue,
                    labelColor: CbsColors.white,
                    tabs: [
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CbsColors.primaryBlue, width: 1.5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text("Tout"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CbsColors.primaryBlue, width: 1.5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text("En cours"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CbsColors.primaryBlue, width: 1.5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text("Terminé"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                gapH10,
                SizedBox(
                  width: double.maxFinite,
                  height: 606,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.builder(
                          padding: const EdgeInsets.only(top: 20.0),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return CourseCard(
                              onPressed: _nextPage,
                            );
                          }),
                      ListView.builder(
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return CourseCard(
                              onPressed: _nextPage,
                            );
                          }),
                      ListView.builder(
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return CourseCard(
                              onPressed: _nextPage,
                            );
                          }),
                    ],
                  ),
                )
              ],
            ),
            LessonPage(),
          ],
        ),
      ),
    );
  }
}
