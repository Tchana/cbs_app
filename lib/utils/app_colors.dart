import 'package:flutter/material.dart';

// -----------------------------------------------------------------------------
// Cbs Yaoundé — Complete color system
// Merges guide_couleurs_Cbs.html (light) + guide_couleurs_Cbs_dark.html
// -----------------------------------------------------------------------------

class CbsColors {
  // ===========================================================================
  // 1. BASE PALETTE (IDENTICAL IN BOTH MODES)
  // ===========================================================================
  static const Color brandBrown = Color(0xFF4A2C0A); // Marron universitaire
  static const Color brandGold = Color(0xFFF0C040); // Or vif
  static const Color brandIvory =
      Color(0xFFFAF5EE); // Ivoire chaud (light mode bg)

  // Extended palette (shared)
  static const Color brownMedium = Color(0xFF6B3F15); // hover, active links
  static const Color sandLight =
      Color(0xFFF5EDE0); // icon backgrounds, secondary cards (light)
  static const Color creamDark =
      Color(0xFFEDE0CC); // borders/dividers/progress bg (light)
  static const Color goldPale =
      Color(0xFFFDF3D0); // payment cards, soft alerts (light)
  static const Color goldDeep =
      Color(0xFFD4A020); // gold borders, secondary icons
  static const Color brownNight =
      Color(0xFF2C1A08); // primary dark text on light
  static const Color caramel =
      Color(0xFFC4956A); // secondary text on brown header
  static const Color warmGrey =
      Color(0xFF7A6E64); // metadata/secondary labels (light)

  // Status colors (unchanged)
  static const Color paidGreen = Color(0xFF0F6E56); // confirmed amounts
  static const Color dangerRed = Color(0xFFC0392B);

  // ===========================================================================
  // 2. LIGHT MODE SPECIFIC (guide_couleurs_Cbs.html)
  // ===========================================================================
  static const Color lightBg =
      Color(0xFFF8F5F0); // fallback, main is brandIvory
  static const Color lightCardWhite = Color(0xFFFFFFFF); // white cards
  static const Color lightBorder = Color(0xFFEDE0CC); // creamDark alias
  static const Color lightTextPrimary = Color(0xFF1A2E28);
  static const Color lightTextSecondary = Color(0xFF5A4030);
  static const Color lightTextMetadata = Color(0xFF7A6E64);
  static const Color lightButtonSecondary = Color(0xFF4A2C0A);

  // Light component aliases (readable)
  static const Color lightAppBarBg = brandBrown;
  static const Color lightAppBarText = brandIvory;
  static const Color lightAppBarSubtext = caramel;
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightCardBorder = creamDark;
  static const Color lightCardActiveBg = sandLight;
  static const Color lightCardActiveBorder = brownMedium;
  static const Color lightIconBg = sandLight;
  static const Color lightBadgeBg = goldPale;
  static const Color lightBadgeText = Color(0xFF5C3D08);
  static const Color lightBadgeBorder = goldDeep;
  static const Color lightProgressBg = creamDark;
  static const Color lightProgressFill = brandGold;
  static const Color lightPaymentCardBg = goldPale;
  static const Color lightPaymentCardBorder = goldDeep;
  static const Color lightTabActiveBg = brandGold;
  static const Color lightTabActiveText = brownNight;
  static const Color lightTabInactiveText = caramel;
  static const Color lightTabInactiveBorder = brownMedium;
  static const Color lightNavActiveText = brandBrown;
  static const Color lightNavInactiveText = warmGrey;
  static const Color lightNavActiveDot = brandGold;
  static const Color lightDivider = creamDark;

  // ===========================================================================
  // 3. DARK MODE SPECIFIC (guide_couleurs_Cbs_dark.html)
  // ===========================================================================
  static const Color darkBg = Color(0xFF0E0A05); // fond général
  static const Color darkSurface =
      Color(0xFF1C1208); // cartes principales / header
  static const Color darkElevated =
      Color(0xFF2A1C0C); // surfaces élevées (cards secondaires, icônes)
  static const Color darkBorder =
      Color(0xFF3A2510); // bordures, séparateurs, progress bg
  static const Color darkBorderActive = Color(0xFF4A3018);
  static const Color darkCardActive = Color(0xFF2A1C0C);
  static const Color darkCardActiveBorder = goldDeep;
  static const Color darkTextPrimary = brandIvory; // ivoire chaud
  static const Color darkTextSecondary = caramel; // caramel
  static const Color darkTextMetadata = Color(0xFF5A4A38); // métadonnées
  static const Color darkButtonSecondaryBg = brandBrown; // marron universitaire
  static const Color darkButtonSecondaryText = brandGold;
  static const Color darkIconBg = Color(0xFF2A1C0C);
  static const Color darkBadgeBg = Color(0xFF2A1C0C);
  static const Color darkBadgeText = brandGold;
  static const Color darkBadgeBorder = goldDeep;
  static const Color darkProgressBg = Color(0xFF3A2510);
  static const Color darkProgressFill = brandGold;
  static const Color darkPaymentCardBg = Color(0xFF2A1C0C);
  static const Color darkPaymentCardBorder = goldDeep;
  static const Color darkTabActiveBg = brandGold;
  static const Color darkTabActiveText = brownNight;
  static const Color darkTabInactiveText = caramel;
  static const Color darkTabInactiveBorder = Color(0xFF3A2510);
  static const Color darkNavBg = Color(0xFF1C1208);
  static const Color darkNavActiveText = brandGold;
  static const Color darkNavInactiveText = Color(0xFF5A4A38);
  static const Color darkNavActiveDot = brandGold;
  static const Color darkDivider = Color(0xFF3A2510);
  static const Color darkAvatarBg = brandGold;
  static const Color darkAvatarText = brownNight;

  // Dark mode component aliases (consistent with guide table)
  static const Color darkHeaderBg = darkSurface;
  static const Color darkHeaderText = darkTextPrimary;
  static const Color darkHeaderSubtext = darkTextSecondary;
  static const Color darkCardBg = darkSurface;
  static const Color darkCardBorder = darkBorder;

  // ===========================================================================
  // 4. MATERIAL COLOR SWATCHES (for backward compatibility)
  // ===========================================================================
  static const white = MaterialColor(0xFFFAF5EE, {
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFCF8),
    200: Color(0xFFFAF5EE),
    300: Color(0xFFF5EDE0),
    400: Color(0xFFEDE0CC),
    500: Color(0xFFDBC8AE),
    600: Color(0xFFC8B08A),
    700: Color(0xFFB39462),
    800: Color(0xFF96713A),
    900: Color(0xFF744A17),
  });

  static const backgroundColor = MaterialColor(0xFFFAF5EE, {
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFCF8),
    200: Color(0xFFFAF5EE),
    300: Color(0xFFF5EDE0),
    400: Color(0xFFEDE0CC),
    500: Color(0xFFDBC8AE),
    600: Color(0xFFC8B08A),
    700: Color(0xFFB39462),
    800: Color(0xFF96713A),
    900: Color(0xFF744A17),
  });

  static const primaryRed = MaterialColor(0xFFC0392B, {
    50: Color(0xFFFFF2F0),
    100: Color(0xFFFFD8D2),
    200: Color(0xFFFFB3A8),
    300: Color(0xFFFF8A7B),
    400: Color(0xFFFF6654),
    500: Color(0xFFE24D3B),
    600: Color(0xFFC0392B),
  });

  static const primaryBrown = MaterialColor(0xFF4A2C0A, {
    50: Color(0xFFFBF7F2),
    100: Color(0xFFF4E9DC),
    200: Color(0xFFE7D2B8),
    300: Color(0xFFD3B389),
    400: Color(0xFFB98E54),
    500: Color(0xFF8C6130),
    600: Color(0xFF4A2C0A),
  });

  static const primaryYellow = MaterialColor(0xFFF0C040, {
    600: Color(0xFFF0C040),
  });

  static const primaryGrey = MaterialColor(0xFFEDE0CC, {
    600: Color(0xFFEDE0CC),
  });

  static const primaryDark = MaterialColor(0xFF2C1A08, {
    100: Color(0xFFEDE5DC),
    200: Color(0xFFD8C8B3),
    300: Color(0xFFC1A684),
    400: Color(0xFFA78052),
    500: Color(0xFF7A5B33),
    600: Color(0xFF5D4122),
    700: Color(0xFF4A2C0A),
    800: Color(0xFF2C1A08),
    900: Color(0xFF1A1008),
    1000: Color(0xFF0F0904),
  });

  static const mainBaseGrey = MaterialColor(0xFFFAF5EE, {
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFCF8),
    300: Color(0xFFFAF5EE),
    400: Color(0xFFF5EDE0),
    500: Color(0xFFEDE0CC),
    600: Color(0xFFDBC8AE),
    700: Color(0xFFC8B08A),
    800: Color(0xFFB39462),
    900: Color(0xFF96713A),
    1000: Color(0xFF744A17),
    1100: Color(0xFF4A2C0A),
  });

  static const errorColor = MaterialColor(0xFFC0392B, {
    100: Color(0xFFFFF2F0),
    200: Color(0xFFFFD8D2),
    300: Color(0xFFFFB3A8),
    400: Color(0xFFFF8A7B),
    500: Color(0xFFE24D3B),
    600: Color(0xFFC0392B),
  });

  static const successColor = MaterialColor(0xFF0F6E56, {
    100: Color(0xFFE7F5F1),
    200: Color(0xFFBFE6DD),
    300: Color(0xFF86CDBB),
    400: Color(0xFF49AF96),
    500: Color(0xFF0F6E56),
  });

  // ===========================================================================
  // 5. LEGACY / DEPRECATED ALIASES (backward compatibility)
  // ===========================================================================
  @Deprecated('Use brandIvory')
  static const Color brandWhite = brandIvory;
  @Deprecated('Use brownMedium / brandBrown / brandGold')
  static const Color brandBlue = brownMedium;
  @Deprecated('Use brownNight / darkBorder')
  static const Color brandDeepBlue = brownNight;
  @Deprecated('Use brownMedium / brandGold / brandBrown depending on use')
  static const Color primaryBlue = brownMedium;

  @Deprecated('Use lightAppBarBg')
  static const Color appBarColor = brandBrown;
  @Deprecated('Use lightAppBarText')
  static const Color appBarTextColor = brandIvory;
  @Deprecated('Use warmGrey')
  static const Color hintColor = warmGrey;
  @Deprecated('Use sandLight')
  static const Color featureColor = sandLight;

  // Renamed tokens (keep app compiling during migration)
  @Deprecated('Use darkTextPrimary')
  static const Color darkText = darkTextPrimary;
  @Deprecated('Use darkTextSecondary')
  static const Color darkHint = darkTextSecondary;
  @Deprecated('Use darkElevated')
  static const Color darkCard = darkElevated;
}
