import 'package:flutter/material.dart';

import '../../../../config/app_config.dart';

/// Domain entity representing a loyalty tier derived from a points balance.
/// Holds only raw data — all display formatting belongs in the presentation layer.
class LoyaltyTier {
  final String name;         // lowercase key: 'blue' | 'silver' | 'gold' | 'platinum'
  final Color color;
  final double progress;     // 0.0–1.0 across the full progress bar
  final int? pointsToNext;   // null when at max tier (Platinum)
  final String? nextTier;    // lowercase key of the next tier, null at max
  final String expiryDate;   // raw date string, formatted by the UI
  final int index;           // 0=Blue, 1=Silver, 2=Gold, 3=Platinum

  const LoyaltyTier({
    required this.name,
    required this.color,
    required this.progress,
    required this.pointsToNext,
    required this.nextTier,
    required this.expiryDate,
    required this.index,
  });

  factory LoyaltyTier.fromPoints(double points) {
    if (points < AppConfig.tier1Boundary) {
      final progress = (points / AppConfig.tier1Boundary) * 0.333;
      return LoyaltyTier(
        name: 'blue',
        color: AppConfig.tier1Color,
        progress: progress.clamp(0.0, 0.333),
        pointsToNext: (AppConfig.tier1Boundary - points).ceil(),
        nextTier: 'silver',
        expiryDate: '—',
        index: 0,
      );
    } else if (points < AppConfig.tier2Boundary) {
      final progress = 0.333 +
          ((points - AppConfig.tier1Boundary) /
                  (AppConfig.tier2Boundary - AppConfig.tier1Boundary)) *
              0.333;
      return LoyaltyTier(
        name: 'silver',
        color: AppConfig.tier2Color,
        progress: progress.clamp(0.333, 0.667),
        pointsToNext: (AppConfig.tier2Boundary - points).ceil(),
        nextTier: 'gold',
        expiryDate: '—',
        index: 1,
      );
    } else if (points < AppConfig.tier3Boundary) {
      final progress = 0.667 +
          ((points - AppConfig.tier2Boundary) /
                  (AppConfig.tier3Boundary - AppConfig.tier2Boundary)) *
              0.333;
      return LoyaltyTier(
        name: 'gold',
        color: AppConfig.tier3Color,
        progress: progress.clamp(0.667, 1.0),
        pointsToNext: (AppConfig.tier3Boundary - points).ceil(),
        nextTier: 'platinum',
        expiryDate: '—',
        index: 2,
      );
    } else {
      return LoyaltyTier(
        name: 'platinum',
        color: AppConfig.tier4Color,
        progress: 1.0,
        pointsToNext: null,
        nextTier: null,
        expiryDate: '—',
        index: 3,
      );
    }
  }
}
