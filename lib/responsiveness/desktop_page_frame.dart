import 'dart:math' as math;

import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:flutter/material.dart';

/// Centers page content and caps its width on desktop / tablet.
class DesktopPageFrame extends StatelessWidget {
  const DesktopPageFrame({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final cap = maxWidth ?? Adaptive.contentMaxWidth(context);
    final insets = padding ?? Adaptive.pagePadding(context);
    final content = Padding(padding: insets, child: child);

    if (!Adaptive.isDesktop(context)) {
      return content;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(cap, constraints.maxWidth);
        final height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : null;
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: width,
            height: height,
            child: content,
          ),
        );
      },
    );
  }
}
