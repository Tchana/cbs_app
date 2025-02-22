import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/teacher_data/teacher_data.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/shared/custom_button.dart';
import 'package:center_for_biblical_studies/shared/section_header.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DataController dataController = Get.find<DataController>();

  bool? loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: const CircleAvatar(
                      radius: 34,
                      backgroundColor: CbsColors.primaryGrey,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Inscrivez-vous",
                                style: mediumStyle24Medium.copyWith(
                                    color: CbsColors.darkBlue),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Icon(
                                        Icons.notifications_none_outlined),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child:
                                        const Icon(Icons.bookmark_add_outlined),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "Vous avez déjà un compte ? Connectez-vous",
                            style: verySmallStyle12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              gapH12,
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  hintText: "Rechercher",
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: CbsColors.primaryBrown,
                    size: 17,
                  ),
                ),
              ),
              gapH32,
              Container(
                width: double.maxFinite,
                height: 200,
                decoration: BoxDecoration(
                  color: CbsColors.primaryBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: CbsColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.play_circle_outline,
                            size: 150,
                            color: CbsColors.primaryGrey,
                          ),
                        ),
                      ),
                      gapW12,
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Bienvenue dans CBS!",
                              style: smallStyle18.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: CbsColors.white),
                            ),
                            Text(
                              "Vidéo introductive et descriptive de CBS",
                              style: verySmallStyle15.copyWith(
                                  color: CbsColors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              gapH32,
              SectionHeader(title: "Enseignants", moreText: "Voir tout"),
              gapH32,
              Obx(() {
                return loading!
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: dataController.teachers
                            .map((teacher) {
                              return teacherCard(teacher: teacher);
                            })
                            .take(3)
                            .toList(),
                      );
              }),
              gapH32,
              SectionHeader(title: "Cours", moreText: "Voir tout"),
              Obx(() {
                return loading!
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: dataController.courses
                            .map((course) {
                              return CourseCard(courseData: course);
                            })
                            .take(3)
                            .toList(),
                      );
              }),
              gapH32,
            ],
          ),
        ),
      ),
    );
  }

  Widget teacherCard({TeacherData? teacher}) {
    return SizedBox(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: CbsColors.primaryGrey,
          ),
          gapH10,
          Text(
            "Theopile B.",
            style: verySmallStyle14.copyWith(
                fontWeight: FontWeight.bold, color: CbsColors.primaryBlue),
          ),
          gapH8,
          const Text(
            "Théologie appliquée",
            style: verySmallStyle8,
          ),
          gapH8,
          Text(
            "22 Cours",
            style: verySmallStyle14.copyWith(
                fontWeight: FontWeight.w300, color: CbsColors.primaryBlue),
          ),
          gapH8,
          CbsButton(
            width: 100,
            height: 30,
            bgColor: CbsColors.primaryBlue,
            onPressed: () {},
            child: Text(
              "Contacter",
              style: verySmallStyle10.copyWith(
                  fontWeight: FontWeight.bold, color: CbsColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
