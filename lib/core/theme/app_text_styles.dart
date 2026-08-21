import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle h1({Color color = AppColors.lightOnBackground}) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.2,
      );

  static TextStyle h2({Color color = AppColors.primary}) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.2,
      );

  static TextStyle h3({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w600,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 20,
        fontWeight: weight,
        color: color,
      );

  /// Large serif display (prices, section titles).
  static TextStyle display({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w700,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 36,
        fontWeight: weight,
        color: color,
        height: 1.2,
      );

  // Body - Manrope
  static TextStyle bodyLarge({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 16,
        fontWeight: weight,
        color: color,
      );

  static TextStyle bodyMedium({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 14,
        fontWeight: weight,
        color: color,
      );

  static TextStyle bodySmall({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 12,
        fontWeight: weight,
        color: color,
      );

  static TextStyle labelLarge({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w600,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 14,
        fontWeight: weight,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle button({Color color = AppColors.lightOnPrimary}) =>
      TextStyle(
        fontFamily: 'Manrope',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headlineMd({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 28,
        fontWeight: weight,
        color: color,
        height: 1.3,
      );

  static TextStyle labelCaps({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w600,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 10,
        fontWeight: weight,
        color: color,
        letterSpacing: 1.2,
        height: 1.0,
      );

  static TextStyle caption({Color color = AppColors.lightOnBackground}) =>
      TextStyle(
        fontFamily: 'Manrope',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 1.5,
      );

  // Serif headline/display - EBGaramond

  /// 30 serif headline (screen titles).
  static TextStyle headline({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 30,
        fontWeight: weight,
        color: color,
        height: 1.3,
      );

  /// 24 serif headline (section titles).
  static TextStyle headlineSm({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 24,
        fontWeight: weight,
        color: color,
      );

  /// 22 serif title.
  static TextStyle title({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 22,
        fontWeight: weight,
        color: color,
        height: 1.27,
      );

  /// 20 serif subtitle.
  static TextStyle subtitle({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 20,
        fontWeight: weight,
        color: color,
      );

  /// 18 serif subtitle.
  static TextStyle subtitleSm({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 18,
        fontWeight: weight,
        color: color,
      );

  /// 17 serif title (product names).
  static TextStyle titleSm({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 17,
        fontWeight: weight,
        color: color,
        height: 1.3,
      );

  /// 16 serif headline (product names).
  static TextStyle headlineXs({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'EBGaramond',
        fontSize: 16,
        fontWeight: weight,
        color: color,
        height: 1.3,
      );

  // Body/label extras - Manrope

  /// 18 body (Manrope).
  static TextStyle bodyLg({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 18,
        fontWeight: weight,
        color: color,
      );

  /// 24 body (Manrope).
  static TextStyle bodyXl({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 24,
        fontWeight: weight,
        color: color,
      );

  /// 13 caption (Manrope).
  static TextStyle captionSm({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 13,
        fontWeight: weight,
        color: color,
      );

  /// 11 label (Manrope).
  static TextStyle labelXs({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 11,
        fontWeight: weight,
        color: color,
      );

  /// 10 label (Manrope).
  static TextStyle labelMicro({
    Color color = AppColors.lightOnBackground,
    FontWeight weight = FontWeight.w600,
  }) => TextStyle(
        fontFamily: 'Manrope',
        fontSize: 10,
        fontWeight: weight,
        color: color,
      );
}
