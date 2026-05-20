import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_design_constants.dart';
import 'app_text_styles.dart';

ThemeData createLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightSurface,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      tertiary: AppColors.lightTertiary,
      onTertiary: AppColors.lightOnTertiary,
      tertiaryContainer: AppColors.lightTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutlineVariant,
      surfaceContainerHighest: AppColors.lightBackground,
      onSurfaceVariant: AppColors.lightOnSurface,
      surfaceContainerLow: AppColors.lightSurface,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1(color: AppColors.lightOnSurface),
      displayMedium: AppTextStyles.h2(color: AppColors.lightOnSurface),
      displaySmall: AppTextStyles.h3(color: AppColors.lightOnSurface),
      headlineMedium: AppTextStyles.headlineMd(color: AppColors.lightOnSurface),
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.lightOnSurface),
      bodyMedium: AppTextStyles.bodyMedium(color: AppColors.lightOnSurface),
      bodySmall: AppTextStyles.bodySmall(color: AppColors.lightOnSurface),
      labelLarge: AppTextStyles.labelCaps(color: AppColors.lightOnSurface),
      labelSmall: AppTextStyles.labelCaps(color: AppColors.lightPrimaryContainer),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.h2(color: AppColors.primary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDesignConstants.radiusMedium,
        side: const BorderSide(color: AppColors.lightOutlineVariant, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.lightOnPrimary,
        textStyle: AppTextStyles.button(color: AppColors.lightOnPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: AppDesignConstants.radiusMedium,
        ),
        elevation: 0,
      ),
    ),
  );
}
