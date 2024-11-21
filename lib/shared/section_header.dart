import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, this.title, this.moreText, this.onTap});
  final String? title, moreText;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            style: smallStyle18.copyWith(
                fontWeight: FontWeight.bold, color: CbsColors.darkBlue),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(
              moreText!,
              style: smallStyle18.copyWith(color: CbsColors.primaryBrown),
            ),
          ),
        ],
      ),
    );
  }
}
