import 'package:flutter/material.dart';

import '../../../../config/app_config.dart';

class LoyaltyTier {
  final String name;
  final Color color;
  final double progress;
  final String targetText;
  final String expiryText;
  final int index;

  const LoyaltyTier({
    required this.name,
    required this.color,
    required this.progress,
    required this.targetText,
    required this.expiryText,
    required this.index,
  });

  factory LoyaltyTier.fromPoints(double points) {
    if (points < AppConfig.tier1Boundary) {
      final progress = (points / AppConfig.tier1Boundary) * 0.333;
      final remaining = (AppConfig.tier1Boundary - points).ceil();
      return LoyaltyTier(
        name: 'Blue',
        color: AppConfig.tier1Color,
        progress: progress.clamp(0.0, 0.333),
        targetText: '$remaining points to Silver',
        expiryText: 'Expires on 22/12/2022',
        index: 0,
      );
    } else if (points < AppConfig.tier2Boundary) {
      final progress = 0.333 +
          ((points - AppConfig.tier1Boundary) /
                  (AppConfig.tier2Boundary - AppConfig.tier1Boundary)) *
              0.333;
      final remaining = (AppConfig.tier2Boundary - points).ceil();
      return LoyaltyTier(
        name: 'Silver',
        color: AppConfig.tier2Color,
        progress: progress.clamp(0.333, 0.667),
        targetText: '$remaining points to Gold',
        expiryText: 'Expires on 22/12/2023',
        index: 1,
      );
    } else if (points < AppConfig.tier3Boundary) {
      final progress = 0.667 +
          ((points - AppConfig.tier2Boundary) /
                  (AppConfig.tier3Boundary - AppConfig.tier2Boundary)) *
              0.333;
      final remaining = (AppConfig.tier3Boundary - points).ceil();
      return LoyaltyTier(
        name: 'Gold',
        color: AppConfig.tier3Color,
        progress: progress.clamp(0.667, 1.0),
        targetText: '$remaining points to Platinum',
        expiryText: 'Expires on 22/12/2024',
        index: 2,
      );
    } else {
      return LoyaltyTier(
        name: 'Platinum',
        color: AppConfig.tier4Color,
        progress: 1.0,
        targetText: 'Maximum Tier Reached',
        expiryText: 'Expires on 22/12/2025',
        index: 3,
      );
    }
  }
}
