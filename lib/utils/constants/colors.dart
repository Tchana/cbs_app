import 'package:flutter/material.dart';

class CustomColors {
  CustomColors._();

  static const Color darkBlue = Color(0xff1E2E3D);
  static const Color darkerBlue = Color(0xff291F1E);
  //static const Color darkestBlue = Color(0xff080113);

  static const List<Color> defaultGradient = [
    darkBlue,
    darkerBlue,
    //darkestBlue,
  ];

  // App Basic colors
  static const Color primaryColor = Color(0xFF6610F2);
  static const Color secondaryColor = Color(0xFF291F1E);
  static const Color accent = Color(0xFFC4D6B0);

  // Gradient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      primaryColor,
      secondaryColor,
      accent,
    ],
  );

  // Text colors
  static const Color textPrimary = Color(0xFF2A2D34);
  static const Color textSecondary = Color(0xFFA6A6A6);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color lightBackground = Color(0xFFF6F6F6);
  static const Color darkBackground = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFE0FBFC);

  // Background container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = white.withValues(alpha: 0.1);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF6610F2);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
