import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Light + dark [ThemeData] built from [CbsColors] (Cbs color guides).
abstract final class CbsTheme {
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: CbsColors.brandBrown,
      onPrimary: CbsColors.brandIvory,
      secondary: CbsColors.brandGold,
      onSecondary: CbsColors.brownNight,
      error: CbsColors.dangerRed,
      onError: CbsColors.brandIvory,
      surface: CbsColors.lightCardBg,
      onSurface: CbsColors.brownNight,
      surfaceContainerHighest: CbsColors.sandLight,
      outline: CbsColors.lightDivider,
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: CbsColors.brandBrown,
      scaffoldBackgroundColor: CbsColors.brandIvory,
      cardColor: CbsColors.lightCardBg,
      dividerColor: CbsColors.lightDivider,
      hintColor: CbsColors.warmGrey,
      appBarTheme: const AppBarTheme(
        backgroundColor: CbsColors.lightAppBarBg,
        foregroundColor: CbsColors.lightAppBarText,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: CbsColors.lightAppBarText),
        titleTextStyle: TextStyle(
          color: CbsColors.lightAppBarText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: CbsColors.brandBrown),
      textTheme: ThemeData.light().textTheme.apply(
            bodyColor: CbsColors.brownNight,
            displayColor: CbsColors.brandBrown,
          ),
      dividerTheme: const DividerThemeData(
        color: CbsColors.lightDivider,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: CbsColors.lightCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: CbsColors.lightCardBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: CbsColors.brandGold,
          foregroundColor: CbsColors.brownNight,
          disabledBackgroundColor: CbsColors.creamDark,
          disabledForegroundColor: CbsColors.warmGrey,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CbsColors.lightButtonSecondary,
          foregroundColor: CbsColors.brandGold,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: CbsColors.brownMedium),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CbsColors.sandLight,
        hintStyle: const TextStyle(color: CbsColors.warmGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CbsColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CbsColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CbsColors.brandBrown, width: 2),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: CbsColors.lightTabActiveText,
        unselectedLabelColor: CbsColors.lightTabInactiveText,
        indicatorColor: CbsColors.lightTabActiveBg,
        dividerColor: CbsColors.lightDivider,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CbsColors.lightCardBg,
        selectedItemColor: CbsColors.lightNavActiveText,
        unselectedItemColor: CbsColors.lightNavInactiveText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: CbsColors.lightProgressFill,
        linearTrackColor: CbsColors.lightProgressBg,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CbsColors.brandBrown,
        contentTextStyle: const TextStyle(color: CbsColors.brandIvory),
        actionTextColor: CbsColors.brandGold,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CbsColors.brandGold,
        foregroundColor: CbsColors.brownNight,
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: CbsColors.brandGold,
      brightness: Brightness.dark,
      surface: CbsColors.darkSurface,
    ).copyWith(
      // Guide: gold is primary accent in dark mode.
      primary: CbsColors.brandGold,
      onPrimary: CbsColors.brownNight,
      // Guide: brown is secondary action/background accent.
      secondary: CbsColors.brandBrown,
      onSecondary: CbsColors.brandIvory,
      surface: CbsColors.darkSurface,
      onSurface: CbsColors.darkTextPrimary,
      surfaceContainerHighest: CbsColors.darkElevated,
      outline: CbsColors.darkBorder,
      error: CbsColors.dangerRed,
      onError: CbsColors.brandIvory,
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: CbsColors.brandGold,
      scaffoldBackgroundColor: CbsColors.darkBg,
      // Default card surface should be the main card surface (#1C1208).
      cardColor: CbsColors.darkSurface,
      dividerColor: CbsColors.darkDivider,
      hintColor: CbsColors.darkTextSecondary,
      appBarTheme: const AppBarTheme(
        backgroundColor: CbsColors.darkHeaderBg,
        foregroundColor: CbsColors.darkHeaderText,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: CbsColors.darkHeaderText),
        titleTextStyle: TextStyle(
          color: CbsColors.darkHeaderText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: CbsColors.darkTextPrimary),
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: CbsColors.darkTextPrimary,
            displayColor: CbsColors.darkTextPrimary,
          ),
      dividerTheme: const DividerThemeData(
        color: CbsColors.darkDivider,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: CbsColors.darkSurface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: CbsColors.darkCardBorder),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: CbsColors.brandGold,
          foregroundColor: CbsColors.brownNight,
          disabledBackgroundColor: CbsColors.darkBorder,
          disabledForegroundColor: CbsColors.darkTextMetadata,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CbsColors.darkButtonSecondaryBg,
          foregroundColor: CbsColors.darkButtonSecondaryText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: CbsColors.brandGold),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CbsColors.brandGold,
          side: const BorderSide(color: CbsColors.darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CbsColors.darkElevated,
        hintStyle: const TextStyle(color: CbsColors.darkTextSecondary),
        labelStyle: const TextStyle(color: CbsColors.darkTextSecondary),
        floatingLabelStyle: const TextStyle(color: CbsColors.brandGold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CbsColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CbsColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: CbsColors.brandGold, width: 2),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: CbsColors.darkTabActiveText,
        unselectedLabelColor: CbsColors.darkTabInactiveText,
        indicatorColor: CbsColors.darkTabActiveBg,
        dividerColor: CbsColors.darkDivider,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: CbsColors.darkElevated,
        selectedColor: CbsColors.brandGold,
        disabledColor: CbsColors.darkBorder,
        labelStyle: const TextStyle(color: CbsColors.darkTextPrimary),
        secondaryLabelStyle: const TextStyle(color: CbsColors.brownNight),
        side: const BorderSide(color: CbsColors.darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: CbsColors.darkTextPrimary,
        textColor: CbsColors.darkTextPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CbsColors.darkNavBg,
        selectedItemColor: CbsColors.darkNavActiveText,
        unselectedItemColor: CbsColors.brandIvory,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: CbsColors.darkNavBg,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(size: 22),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: CbsColors.darkProgressFill,
        linearTrackColor: CbsColors.darkProgressBg,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CbsColors.darkSurface,
        contentTextStyle: const TextStyle(color: CbsColors.darkTextPrimary),
        actionTextColor: CbsColors.brandGold,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CbsColors.brandGold,
        foregroundColor: CbsColors.brownNight,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: CbsColors.darkSurface,
        modalBackgroundColor: CbsColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        dragHandleColor: CbsColors.darkBorder,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: CbsColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: CbsColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        contentTextStyle: TextStyle(
          color: CbsColors.darkTextSecondary,
          fontSize: 14,
          height: 1.35,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? CbsColors.brandGold
              : CbsColors.darkTextMetadata,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? CbsColors.brandGold.withValues(alpha: 0.35)
              : CbsColors.darkBorder,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? CbsColors.brandGold
              : null,
        ),
        checkColor: const WidgetStatePropertyAll(CbsColors.brownNight),
        side: const BorderSide(color: CbsColors.darkBorder),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? CbsColors.brandGold
              : null,
        ),
      ),
    );
  }
}
