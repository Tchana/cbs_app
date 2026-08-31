import 'package:flutter/material.dart';

/// Layout breakpoints used across the CBS app.
class Breakpoints {
  Breakpoints._();

  /// Phone / compact.
  static const double compact = 800;

  /// Tablet / medium.
  static const double medium = 1200;
}

/// Adaptive helpers for phone, tablet, and desktop layouts.
class Adaptive {
  Adaptive._();

  static Size sizeOf(BuildContext context) => MediaQuery.sizeOf(context);

  static bool isCompact(BuildContext context) =>
      sizeOf(context).width < Breakpoints.compact;

  static bool isMedium(BuildContext context) {
    final w = sizeOf(context).width;
    return w >= Breakpoints.compact && w <= Breakpoints.medium;
  }

  static bool isExpanded(BuildContext context) =>
      sizeOf(context).width > Breakpoints.medium;

  /// Tablet or desktop (sidebar navigation, wider content).
  static bool isDesktop(BuildContext context) =>
      sizeOf(context).width >= Breakpoints.compact;

  static double contentMaxWidth(BuildContext context) {
    if (isExpanded(context)) return 1280;
    if (isMedium(context)) return 980;
    return double.infinity;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    if (isExpanded(context)) {
      return const EdgeInsets.fromLTRB(32, 20, 32, 32);
    }
    if (isMedium(context)) {
      return const EdgeInsets.fromLTRB(24, 16, 24, 24);
    }
    return const EdgeInsets.fromLTRB(20, 16, 20, 24);
  }

  static int bookColumns(BuildContext context) {
    final w = sizeOf(context).width;
    if (w >= 1600) return 7;
    if (w >= 1200) return 6;
    if (w >= 1000) return 5;
    if (w >= 800) return 4;
    if (w >= 520) return 3;
    return 2;
  }

  static int courseColumns(BuildContext context) {
    final w = sizeOf(context).width;
    if (w >= 800) return 4;
    return 1;
  }

  static int forumColumns(BuildContext context) {
    final w = sizeOf(context).width;
    if (w >= 1400) return 3;
    if (w >= 900) return 2;
    return 1;
  }

  static double bookAspectRatio(BuildContext context) =>
      isDesktop(context) ? 0.62 : 0.58;
}
