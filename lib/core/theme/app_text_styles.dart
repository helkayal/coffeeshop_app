import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle h1({Color color = AppColors.lightOnBackground}) =>
      GoogleFonts.ebGaramond(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
      );

  static TextStyle h2({Color color = AppColors.primary}) =>
      GoogleFonts.ebGaramond(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.2,
      );

  static TextStyle h3({Color color = AppColors.lightOnBackground}) =>
      GoogleFonts.ebGaramond(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // Body - Manrope
  static TextStyle bodyLarge({Color color = AppColors.lightOnBackground}) =>
      GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodyMedium({Color color = AppColors.lightOnBackground}) =>
      GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodySmall({Color color = AppColors.lightOnBackground}) =>
      GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle labelLarge({Color color = AppColors.lightOnBackground}) =>
      GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle button({Color color = AppColors.lightOnPrimary}) =>
      GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headlineMd({Color color = AppColors.lightOnBackground}) =>
      GoogleFonts.ebGaramond(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.3,
      );

  static TextStyle labelCaps({Color color = AppColors.lightOnBackground}) =>
      GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 1.2,
        height: 1.0,
      );

  static TextStyle caption({Color color = AppColors.lightOnBackground}) =>
      GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 1.5,
      );
}
