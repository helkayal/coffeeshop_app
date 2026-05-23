import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_design_constants.dart';
import 'app_text_styles.dart';

ThemeData createLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
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
      surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      surfaceContainerLow: AppColors.lightSurfaceContainerLow,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1(color: AppColors.lightOnSurface),
      displayMedium: AppTextStyles.h2(color: AppColors.lightPrimary),
      displaySmall: AppTextStyles.h3(color: AppColors.lightOnSurface),
      headlineMedium: AppTextStyles.headlineMd(color: AppColors.lightOnSurface),
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.lightOnSurface),
      bodyMedium: AppTextStyles.bodyMedium(color: AppColors.lightOnSurface),
      bodySmall: AppTextStyles.bodySmall(color: AppColors.lightOnSurfaceVariant),
      labelLarge: AppTextStyles.labelCaps(color: AppColors.lightOnSurfaceVariant),
      labelSmall: AppTextStyles.labelCaps(color: AppColors.lightPrimary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.h2(color: AppColors.lightPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.lightSurfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDesignConstants.radiusMedium,
        side: BorderSide(color: AppColors.lightOutlineVariant, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
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
