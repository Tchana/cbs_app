import 'package:flutter/material.dart';

/// Constant sizes to be used in the app (paddings, gaps, rounded corners etc.)
class Sizes {
  static const p4 = 4.0;
  static const p8 = 8.0;
  static const p10 = 10.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p19 = 19.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p26 = 26.0;
  static const p28 = 28.0;
  static const p32 = 32.0;
  static const p36 = 36.0;
  static const p48 = 48.0;
  static const p60 = 60.0;
  static const p64 = 64.0;
}

/// Constant gap widths
const gapW4 = SizedBox(width: Sizes.p4);
const gapW8 = SizedBox(width: Sizes.p8);
const gapW10 = SizedBox(width: Sizes.p10);
const gapW12 = SizedBox(width: Sizes.p12);
const gapW16 = SizedBox(width: Sizes.p16);
const gapW19 = SizedBox(width: Sizes.p19);
const gapW20 = SizedBox(width: Sizes.p20);
const gapW24 = SizedBox(width: Sizes.p24);
const gapW26 = SizedBox(width: Sizes.p26);
const gapW28 = SizedBox(width: Sizes.p28);
const gapW32 = SizedBox(width: Sizes.p32);
const gapW36 = SizedBox(width: Sizes.p36);
const gapW48 = SizedBox(width: Sizes.p48);
const gapW60 = SizedBox(width: Sizes.p60);
const gapW64 = SizedBox(width: Sizes.p64);

/// Constant gap heights
const gapH4 = SizedBox(height: Sizes.p4);
const gapH8 = SizedBox(height: Sizes.p8);
const gapH10 = SizedBox(height: Sizes.p10);
const gapH12 = SizedBox(height: Sizes.p12);
const gapH16 = SizedBox(height: Sizes.p16);
const gapH19 = SizedBox(height: Sizes.p19);
const gapH20 = SizedBox(height: Sizes.p20);
const gapH24 = SizedBox(height: Sizes.p24);
const gapH26 = SizedBox(height: Sizes.p26);
const gapH28 = SizedBox(height: Sizes.p28);
const gapH32 = SizedBox(height: Sizes.p32);
const gapH48 = SizedBox(height: Sizes.p48);
const gapH60 = SizedBox(height: Sizes.p60);
const gapH64 = SizedBox(height: Sizes.p64);

const kpadding = 20.0;

class SizeConfig {
  double heightSize(BuildContext context, double value) {
    value /= 30;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }
}
