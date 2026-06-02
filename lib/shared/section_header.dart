import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, this.title, this.moreText, this.onTap});
  final String? title, moreText;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? CbsColors.darkTextPrimary : CbsColors.primaryBrown[800];
    final moreColor =
        isDark ? CbsColors.brandGold : CbsColors.primaryBrown;
    final showMore =
        moreText != null && moreText!.trim().isNotEmpty && onTap != null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title ?? '',
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
        ),
        if (showMore)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: moreColor,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              moreText!,
              style: smallStyle18.copyWith(
                color: moreColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
