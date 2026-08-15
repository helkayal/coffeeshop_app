import 'package:flutter/material.dart';

import '../../../../config/app_config.dart';
import '../../domain/entities/loyalty_tier.dart';

extension LoyaltyTierStyle on LoyaltyTier {
  Color get color => switch (index) {
    0 => AppConfig.tier1Color,
    1 => AppConfig.tier2Color,
    2 => AppConfig.tier3Color,
    _ => AppConfig.tier4Color,
  };
}
