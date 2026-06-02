import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// Semantic Cbs colors for the current brightness (light / dark guides).
extension CbsColorContext on BuildContext {
  bool get isCbsDark => Theme.of(this).brightness == Brightness.dark;

  Color get CbsScaffoldBg =>
      isCbsDark ? CbsColors.darkBg : CbsColors.brandIvory;

  Color get CbsCardBg =>
      isCbsDark ? CbsColors.darkCardBg : CbsColors.lightCardBg;

  Color get CbsElevatedBg =>
      isCbsDark ? CbsColors.darkElevated : CbsColors.sandLight;

  Color get CbsBorder =>
      isCbsDark ? CbsColors.darkBorder : CbsColors.lightCardBorder;

  Color get CbsTextPrimary =>
      isCbsDark ? CbsColors.darkTextPrimary : CbsColors.brownNight;

  Color get CbsTextSecondary =>
      isCbsDark ? CbsColors.darkTextSecondary : CbsColors.lightTextSecondary;

  Color get CbsTextMetadata =>
      isCbsDark ? CbsColors.darkTextMetadata : CbsColors.lightTextMetadata;

  Color get CbsAccent => CbsColors.brandGold;

  Color get CbsIconOnCard =>
      isCbsDark ? CbsColors.brandGold : CbsColors.brandBrown;
}
