import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.onTapNotification,
    this.onTapFavorites,
    required this.titleIcon,
  });

  final String title;
  final void Function()? onTapNotification;
  final void Function()? onTapFavorites;
  final Icon titleIcon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              titleIcon,
              gapW4,
              Text(
                title,
                style: normalStyle20.copyWith(
                    color: CbsColors.primaryBlue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onTapNotification,
                child: const Icon(
                  Icons.notifications_none_outlined,
                  color: CbsColors.primaryBlue,
                ),
              ),
              gapW4,
              GestureDetector(
                onTap: onTapFavorites,
                child: const Icon(
                  Icons.bookmark_add_outlined,
                  color: CbsColors.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
