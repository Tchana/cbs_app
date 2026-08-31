import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  const ResponsiveWidget({
    super.key,
    required this.largeScreen,
    this.mediumScreen,
    this.smallScreen,
  });

  static bool isSmallScreen(BuildContext context) =>
      Adaptive.isCompact(context);

  static bool isLargeScreen(BuildContext context) =>
      Adaptive.isExpanded(context);

  static bool isMediumScreen(BuildContext context) =>
      Adaptive.isMedium(context);

  static bool isDesktop(BuildContext context) => Adaptive.isDesktop(context);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth <= 1200 &&
            constraints.maxWidth >= 800) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}
