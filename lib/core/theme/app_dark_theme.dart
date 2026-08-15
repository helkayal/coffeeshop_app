import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_design_constants.dart';
import 'app_text_styles.dart';

ThemeData createDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
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
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      surfaceContainerLow: AppColors.darkSurfaceContainerLow,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1(color: AppColors.darkOnBackground),
      displayMedium: AppTextStyles.h2(color: AppColors.primary),
      displaySmall: AppTextStyles.h3(color: AppColors.darkOnBackground),
      headlineMedium: AppTextStyles.headlineMd(
        color: AppColors.darkOnBackground,
      ),
      bodyLarge: AppTextStyles.bodyLarge(color: AppColors.darkOnBackground),
      bodyMedium: AppTextStyles.bodyMedium(color: AppColors.darkOnBackground),
      bodySmall: AppTextStyles.bodySmall(color: AppColors.darkOnSurfaceVariant),
      labelLarge: AppTextStyles.labelCaps(
        color: AppColors.darkOnSurfaceVariant,
      ),
      labelSmall: AppTextStyles.labelCaps(color: AppColors.primary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headlineMd(color: AppColors.primary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDesignConstants.radiusMedium,
        side: BorderSide(
          color: AppColors.darkOutlineVariant.withAlpha(153),
          width: 1,
        ),
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
