import 'package:flutter/material.dart';

import '../../../../config/app_config.dart';
import '../../../../core/theme/app_text_styles.dart';

class LoyaltyPointLabels extends StatelessWidget {
  final int selectedTierIndex;

  const LoyaltyPointLabels({super.key, required this.selectedTierIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        _cell('0 pts', selectedTierIndex == 0, cs, TextAlign.start),
        _cell(
          '${AppConfig.tier1Boundary.toInt()} pts',
          selectedTierIndex == 1,
          cs,
        ),
        _cell(
          '${AppConfig.tier2Boundary.toInt()} pts',
          selectedTierIndex == 2,
          cs,
        ),
        _cell(
          '${AppConfig.tier3Boundary.toInt()} pts',
          selectedTierIndex == 3,
          cs,
          TextAlign.end,
        ),
      ],
    );
  }

  Widget _cell(
    String text,
    bool isActive,
    ColorScheme cs, [
    TextAlign align = TextAlign.center,
  ]) {
    return Expanded(
      child: Text(
        text,
        textAlign: align,
        style: AppTextStyles.labelXs(
          color: isActive ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
