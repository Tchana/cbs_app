import 'package:center_for_biblical_studies/shared/cbs_button.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

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
                "'With fair-tressed Demeter, the sacred goddess, my song begins, With herself and her slim-ankled daughter, whom Aidoneus once Abducted...' Most people are familiar, at least by repute, with the two great epics of Homer, the Iliad and the Odyssey, but few are aware that other poems survive that were attributed to Homer in ancient times. The Homeric Hymns are now known to be the work of various poets working in the same tradition, probably during the seventh and sixth centuries BC. They honour the Greek gods, and recount some of the most attractive of the Greek myths. Four of them (Hymns 2-5) stand out by reason of their length and quality. The Hymn to Demeter tells what happened when Hades, lord of the dead, abducted Persephone, Demeter's daughter.",
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
                        "Theopile B.",
                        style: verySmallStyle12.copyWith(
                            color: CbsColors.primaryDark),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "22 Leçons",
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
                  itemCount: 22,
                  itemBuilder: (BuildContext context, int index) {
                    return lessonCard();
                  })
            ],
          ),
        ],
      ),
    );
  }

  Widget lessonCard() {
    return GestureDetector(
      onTap: () {},
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
                  "Leçon 1: Titre",
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
