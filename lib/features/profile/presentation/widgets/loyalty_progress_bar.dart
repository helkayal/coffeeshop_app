import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../config/app_config.dart';
import 'loyalty_cup_indicator.dart';

class LoyaltyProgressBar extends StatelessWidget {
  final double progress;
  final int selectedTierIndex;

  const LoyaltyProgressBar({
    super.key,
    required this.progress,
    required this.selectedTierIndex,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            const dotSize = 6.0;
            const cupW = 24.0;
            return SizedBox(
              height: 36,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _track(w, cs.surfaceContainerHighest),
                  _track(w * progress, cs.primary),
                  _dot(0, dotSize, progress >= 0.0, cs),
                  _dot(w / 3, dotSize, progress >= 0.333, cs),
                  _dot(2 * w / 3, dotSize, progress >= 0.667, cs),
                  _dot(w, dotSize, progress >= 1.0, cs),
                  Positioned(
                    left: (w - cupW) * progress,
                    top: -12,
                    child: LoyaltyCupIndicator(color: cs.primary),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _pointLabel(
              '0 pts',
              selectedTierIndex == 0,
              cs,
              tt,
              align: TextAlign.left,
            ),
            _pointLabel(
              '${AppConfig.tier1Boundary.toInt()} pts',
              selectedTierIndex == 1,
              cs,
              tt,
            ),
            _pointLabel(
              '${AppConfig.tier2Boundary.toInt()} pts',
              selectedTierIndex == 2,
              cs,
              tt,
            ),
            _pointLabel(
              '${AppConfig.tier3Boundary.toInt()} pts',
              selectedTierIndex == 3,
              cs,
              tt,
              align: TextAlign.right,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _label(
              'loyalty.blue'.tr(),
              isActive: selectedTierIndex == 0,
              cs: cs,
              tt: tt,
              align: TextAlign.left,
            ),
            _label(
              'loyalty.silver'.tr(),
              isActive: selectedTierIndex == 1,
              cs: cs,
              tt: tt,
            ),
            _label(
              'loyalty.gold'.tr(),
              isActive: selectedTierIndex == 2,
              cs: cs,
              tt: tt,
            ),
            _label(
              'loyalty.platinum'.tr(),
              isActive: selectedTierIndex == 3,
              cs: cs,
              tt: tt,
              align: TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }

  Widget _track(double width, Color color) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }

  Widget _dot(double centerX, double size, bool completed, ColorScheme cs) {
    return Positioned(
      left: centerX - size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: completed ? cs.primary : cs.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _pointLabel(
    String text,
    bool isActive,
    ColorScheme cs,
    TextTheme tt, {
    TextAlign align = TextAlign.center,
  }) {
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

  Widget _label(
    String text, {
    required bool isActive,
    required ColorScheme cs,
    required TextTheme tt,
    TextAlign align = TextAlign.center,
  }) {
    return Expanded(
      child: Text(
        text,
        textAlign: align,
        style: tt.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          color: isActive ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
