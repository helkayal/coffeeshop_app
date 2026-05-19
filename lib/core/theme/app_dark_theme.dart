import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_design_constants.dart';
import 'app_text_styles.dart';

ThemeData createDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkSurface,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      onTertiary: AppColors.darkOnTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1(color: AppColors.darkOnSurface),
      displayMedium: AppTextStyles.h2(color: AppColors.darkOnSurface),
      displaySmall: AppTextStyles.h3(color: AppColors.darkOnSurface),
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.darkOnSurface),
      bodyMedium: AppTextStyles.bodyMedium(color: AppColors.darkOnSurface),
      bodySmall: AppTextStyles.bodySmall(color: AppColors.darkOnSurface),
      labelLarge: AppTextStyles.labelLarge(color: AppColors.darkOnSurface),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.h2(color: AppColors.primary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDesignConstants.radiusMedium,
        side: const BorderSide(color: AppColors.darkOutlineVariant, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.darkOnPrimary,
        textStyle: AppTextStyles.button(color: AppColors.darkOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignConstants.radiusMedium,
        ),
        elevation: 0,
      ),
    ),
  );
}
