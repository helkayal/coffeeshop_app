import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';

class ProgressDots extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const ProgressDots({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalSteps, (i) {
        final isCurrent = i == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: AppInsets.h4,
          width: isCurrent ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isCurrent ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        );
      }),
    );
  }
}
