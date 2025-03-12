import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/features/courses/pdf_viewer.dart';
import 'package:center_for_biblical_studies/shared/custom_button.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LessonPage extends StatelessWidget {
  final CourseData? courseData;
  const LessonPage({super.key, this.courseData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description",
                style: largeStyle32Bold.copyWith(color: CbsColors.darkBlue),
              ),
              gapH10,
              Text(
                courseData!.description ?? "",
                style: verySmallStyle12.copyWith(color: CbsColors.primaryDark),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
              gapH16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nom du professeur",
                        style: verySmallStyle15.copyWith(
                            color: CbsColors.primaryBlue,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${courseData!.teacher!.firstName ?? " "} ${courseData!.teacher!.lastName ?? " "}",
                        style: verySmallStyle12.copyWith(
                            color: CbsColors.primaryDark),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${courseData!.lessons!.length.toString()} lessons",
                        style: verySmallStyle15.copyWith(
                            color: CbsColors.primaryBlue,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "30 heures",
                        style: verySmallStyle12.copyWith(
                            color: CbsColors.primaryDark),
                      ),
                    ],
                  ),
                ],
              ),
              gapH12,
              Divider(),
              gapH12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Leçons",
                    style: mediumStyle24Bold.copyWith(
                        color: CbsColors.darkBlue, fontWeight: FontWeight.bold),
                  ),
                  CbsButton(
                    height: 30,
                    onPressed: () {},
                    bgColor: CbsColors.primaryBrown,
                    child: Text(
                      "Commencer",
                      style: verySmallStyle12.copyWith(color: CbsColors.white),
                    ),
                  ),
                ],
              ),
              gapH16,
              ListView.builder(
                  padding: const EdgeInsets.only(top: 20.0),
                  shrinkWrap: true,
                  itemCount: courseData!.lessons!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return lessonCard(index, courseData!.lessons![index]);
                  })
            ],
          ),
        ],
      ),
    );
  }

  Widget lessonCard(int index, LessonData lesson) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => PdfViewerScreen(pdfUrl: lesson.file!),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Leçon ${index + 1}: ${lesson.title}",
                  style: mediumStyle24Bold.copyWith(
                      color: CbsColors.primaryBrown,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Durée: 1 heure",
                  style:
                      verySmallStyle12.copyWith(color: CbsColors.primaryDark),
                ),
              ],
            ),
            Icon(
              Icons.lock_outline_rounded,
              color: CbsColors.primaryBrown,
            )
          ],
        ),
      ),
    );
  }
}
