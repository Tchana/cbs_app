import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  static const int xSmall = 480;
  static const int small = 960;
  static const double medium = 1280;
  static const double large = 1600;
  static const double xLarge = 1920;
  final Widget xSmallBody;
  final Widget smallBody;
  final Widget? mediumBody;
  final Widget? largeBody;
  final Widget xLargeBody;

  const ResponsiveLayout({
    Key? key,
    required this.xSmallBody,
    required this.largeBody,
    this.mediumBody,
    required this.smallBody,
    required this.xLargeBody,
  }) : super(key: key);

  static bool isXSmall(context) {
    return MediaQuery.of(context).size.width <= xSmall;
  }

  static bool isSmall(context) {
    return MediaQuery.of(context).size.width > xSmall &&
        MediaQuery.of(context).size.width <= small;
  }

  static bool isMedium(context) {
    return MediaQuery.of(context).size.width > small &&
        MediaQuery.of(context).size.width <= medium;
  }

  static bool isLarge(context) {
    return MediaQuery.of(context).size.width > medium &&
        MediaQuery.of(context).size.width <= large;
  }

  static bool isXLarge(context) {
    return MediaQuery.of(context).size.width > large &&
        MediaQuery.of(context).size.width <= xLarge;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (isXLarge(context)) {
        return largeBody!;
      }
      if (isLarge(context)) {
        return largeBody!;
      }
      if (isMedium(context)) {
        return mediumBody!;
      }
      if (isSmall(context)) {
        return smallBody;
      }
      return xSmallBody;
    });
  }
}
