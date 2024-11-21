import 'package:center_for_biblical_studies/data/teacher_data/teacher_data.dart';
import 'package:center_for_biblical_studies/shared/cbs_button.dart';
import 'package:center_for_biblical_studies/shared/course_card_widget.dart';
import 'package:center_for_biblical_studies/shared/section_header.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundColor: CbsColors.primaryGrey,
                  ),
                  gapW12,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Inscrivez-vous",
                            style: mediumStyle24Medium.copyWith(
                                color: CbsColors.darkBlue),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              gapW64,
                              gapW12,
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                    Icons.notifications_none_outlined),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(Icons.bookmark_add_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Text(
                        "Vous avez déjà un compte ? Connectez-vous",
                        style: verySmallStyle12,
                      ),
                    ],
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
                    children: [
                      Container(
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
                      gapW12,
                      SizedBox(
                        width: 140,
                        child: Column(
                          children: [
                            Text(
                              "Bienvenu dans CBS!",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  teacherCard(),
                  teacherCard(),
                  teacherCard(),
                ],
              ),
              gapH32,
              SectionHeader(title: "Cours", moreText: "Voir tout"),
              CourseCard(),
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
