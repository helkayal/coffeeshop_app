import 'package:flutter/material.dart';

import '../../../../config/app_config.dart';

class LoyaltyPointLabels extends StatelessWidget {
  final int selectedTierIndex;

  const LoyaltyPointLabels({super.key, required this.selectedTierIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        _cell('0 pts', selectedTierIndex == 0, cs, tt, TextAlign.start),
        _cell(
          '${AppConfig.tier1Boundary.toInt()} pts',
          selectedTierIndex == 1,
          cs,
          tt,
        ),
        _cell(
          '${AppConfig.tier2Boundary.toInt()} pts',
          selectedTierIndex == 2,
          cs,
          tt,
        ),
        _cell(
          '${AppConfig.tier3Boundary.toInt()} pts',
          selectedTierIndex == 3,
          cs,
          tt,
          TextAlign.end,
        ),
      ],
    );
  }

  Widget _cell(
    String text,
    bool isActive,
    ColorScheme cs,
    TextTheme tt, [
    TextAlign align = TextAlign.center,
  ]) {
    return Expanded(
      child: Text(
        text,
        textAlign: align,
        style: tt.bodySmall?.copyWith(
          color: isActive ? cs.primary : cs.onSurfaceVariant,
          fontSize: 11,
        ),
      ),
    );
  }
}
