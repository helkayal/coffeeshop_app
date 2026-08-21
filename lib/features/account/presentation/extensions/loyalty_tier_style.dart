import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/loyalty_tier.dart';

extension LoyaltyTierStyle on LoyaltyTier {
  Color get color => switch (index) {
    0 => AppColors.tier1Color,
    1 => AppColors.tier2Color,
    2 => AppColors.tier3Color,
    _ => AppColors.tier4Color,
  };
}
