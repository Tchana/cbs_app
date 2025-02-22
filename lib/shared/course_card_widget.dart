import 'package:center_for_biblical_studies/data/courses/course_data.dart';
import 'package:center_for_biblical_studies/shared/custom_button.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/constants/colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final CourseData courseData;
  final void Function()? onPressed;

  const CourseCard({
    super.key,
    required this.courseData,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 96,
                  width: 108,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.primaryColor,
                  ),
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      Icons.lock_outline,
                      color: CbsColors.primaryBrown,
                    ),
                  ),
                ),
                Positioned(
                  top: 25,
                  child: Container(
                    height: 72,
                    width: 108,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: CbsColors.primaryGrey,
                    ),
                  ),
                ),
              ],
            ),
            gapW12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseData.title!,
                  style: smallStyle18.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  courseData.id!,
                  style: verySmallStyle15,
                ),
                gapH4,
                Text(
                  courseData.description!,
                  style: verySmallStyle15,
                ),
                gapH4,
                CbsButton(
                  width: MediaQuery.of(context).size.width / 2,
                  bgColor: CbsColors.primaryBrown,
                  onPressed: () {},
                  child: Text(
                    "S’inscrire",
                    style: verySmallStyle10.copyWith(
                        fontWeight: FontWeight.bold, color: CbsColors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
