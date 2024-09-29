import 'package:center_for_biblical_studies/data/teacher_data/teacher_data.dart';
import 'package:center_for_biblical_studies/shared/cbs_button.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String? status;
  final TeacherData? teacherData;
  final void Function()? onPressed;
  final Widget? progress;
  CourseCard(
      {super.key,
      this.status,
      this.teacherData,
      this.progress,
      this.onPressed});

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
                    color: CbsColors.primaryBlue,
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
                  "Intitulé du cours",
                  style: smallStyle18.copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Théophile Bilog",
                  style: verySmallStyle15,
                ),
                gapH4,
                const Text(
                  "Description",
                  style: verySmallStyle15,
                ),
                gapH4,
                CbsButton(
                  width: 200,
                  height: 25,
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
