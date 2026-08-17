import 'package:flutter/material.dart';

import 'app_spacing.dart';

class AppDesignConstants {
  // Spacing (delegated to AppSpacing)
  static const double spacingUnit = AppSpacing.s8;
  static const double paddingSmall = AppSpacing.s8;
  static const double paddingMedium = AppSpacing.s16;
  static const double paddingLarge = AppSpacing.s24;
  static const double paddingExtraLarge = AppSpacing.s32;

  // Border Radius
  static const double borderRadius = 8.0;
  static const double borderRadiusXl = 12.0;
  static const double borderRadius2xl = 16.0;
  static final BorderRadius radiusMedium = BorderRadius.circular(borderRadius);
  static final BorderRadius radiusXl = BorderRadius.circular(borderRadiusXl);
  static final BorderRadius radius2xl = BorderRadius.circular(borderRadius2xl);

  // Elevation / Shadows — use 10% black, theme-neutral
  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0x1A000000),
      offset: const Offset(0, 2),
      blurRadius: 16,
    ),
  ];
}
