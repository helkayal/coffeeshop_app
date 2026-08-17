import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import 'loyalty_cup_indicator.dart';
import 'loyalty_point_labels.dart';
import 'loyalty_tier_labels.dart';

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

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            const dotSize = 8.0;
            const cupW = 24.0;
            return SizedBox(
              height: 36,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    child: _track(w, cs.surfaceContainerHighest),
                  ),
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    child: _track(w * progress, cs.primary),
                  ),
                  _dot(0, dotSize, progress >= 0.0, cs),
                  _dot(w / 3, dotSize, progress >= 0.333, cs),
                  _dot(2 * w / 3, dotSize, progress >= 0.667, cs),
                  _dot(w, dotSize, progress >= 1.0, cs),
                  PositionedDirectional(
                    start: (w - cupW) * progress,
                    top: -10,
                    child: LoyaltyCupIndicator(color: cs.primary),
                  ),
                ],
              ),
            );
          },
        ),
        AppSpacing.v4,
        LoyaltyPointLabels(selectedTierIndex: selectedTierIndex),
        AppSpacing.v4,
        LoyaltyTierLabels(selectedTierIndex: selectedTierIndex),
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
    return PositionedDirectional(
      start: centerX - size / 2,
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
}
