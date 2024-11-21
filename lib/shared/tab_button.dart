import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  const TabButton({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 96),
      decoration: BoxDecoration(
        border: Border.all(color: CbsColors.primaryBlue, width: 1.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(label),
      ),
    );
  }
}
