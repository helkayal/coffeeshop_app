import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppDesignConstants {
  // Spacing
  static const double spacingUnit = 8.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  // Border Radius
  static const double borderRadius = 8.0;
  static const double borderRadiusXl = 12.0;
  static const double borderRadius2xl = 16.0;
  static final BorderRadius radiusMedium = BorderRadius.circular(borderRadius);
  static final BorderRadius radiusXl = BorderRadius.circular(borderRadiusXl);
  static final BorderRadius radius2xl = BorderRadius.circular(borderRadius2xl);

  // Elevation / Shadows
  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: AppColors.lightShadow,
      offset: const Offset(0, 2),
      blurRadius: 16,
    ),
  ];
}
