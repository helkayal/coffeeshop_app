import 'package:flutter/widgets.dart';

class AppSpacing {
  const AppSpacing._();

  // Core scalar values (in points / pixels)
  static const double s1 = 1.0;
  static const double s2 = 2.0;
  static const double s3 = 3.0;
  static const double s4 = 4.0;
  static const double s5 = 5.0;
  static const double s6 = 6.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s15 = 15.0;
  static const double s16 = 16.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s22 = 22.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;
  static const double s40 = 40.0;
  static const double s48 = 48.0;
  static const double s56 = 56.0;
  static const double s64 = 64.0;
  static const double s72 = 72.0;
  static const double s80 = 80.0;
  static const double s96 = 96.0;
  static const double s120 = 120.0;
  static const double s140 = 140.0;

  // Semantic layout aliases
  static const double xxs = s2;
  static const double xs = s4;
  static const double sm = s8;
  static const double md = s16;
  static const double lg = s24;
  static const double xl = s32;
  static const double xxl = s48;

  // Vertical SizedBox gaps (const widgets for zero allocation)
  static const Widget v2 = SizedBox(height: s2);
  static const Widget v3 = SizedBox(height: s3);
  static const Widget v4 = SizedBox(height: s4);
  static const Widget v5 = SizedBox(height: s5);
  static const Widget v6 = SizedBox(height: s6);
  static const Widget v8 = SizedBox(height: s8);
  static const Widget v10 = SizedBox(height: s10);
  static const Widget v12 = SizedBox(height: s12);
  static const Widget v14 = SizedBox(height: s14);
  static const Widget v15 = SizedBox(height: s15);
  static const Widget v16 = SizedBox(height: s16);
  static const Widget v20 = SizedBox(height: s20);
  static const Widget v24 = SizedBox(height: s24);
  static const Widget v32 = SizedBox(height: s32);
  static const Widget v40 = SizedBox(height: s40);
  static const Widget v48 = SizedBox(height: s48);
  static const Widget v96 = SizedBox(height: s96);
  static const Widget v120 = SizedBox(height: s120);

  // Horizontal SizedBox gaps (const widgets for zero allocation)
  static const Widget h2 = SizedBox(width: s2);
  static const Widget h4 = SizedBox(width: s4);
  static const Widget h6 = SizedBox(width: s6);
  static const Widget h8 = SizedBox(width: s8);
  static const Widget h10 = SizedBox(width: s10);
  static const Widget h12 = SizedBox(width: s12);
  static const Widget h14 = SizedBox(width: s14);
  static const Widget h16 = SizedBox(width: s16);
  static const Widget h20 = SizedBox(width: s20);
  static const Widget h24 = SizedBox(width: s24);
  static const Widget h32 = SizedBox(width: s32);
  static const Widget h40 = SizedBox(width: s40);
  static const Widget h80 = SizedBox(width: s80);
}
