import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class LoyaltyTierLabels extends StatelessWidget {
  final int selectedTierIndex;

  const LoyaltyTierLabels({super.key, required this.selectedTierIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        _cell(
          'loyalty.blue'.tr(),
          selectedTierIndex == 0,
          cs,
          align: TextAlign.start,
        ),
        _cell('loyalty.silver'.tr(), selectedTierIndex == 1, cs),
        _cell('loyalty.gold'.tr(), selectedTierIndex == 2, cs),
        _cell(
          'loyalty.platinum'.tr(),
          selectedTierIndex == 3,
          cs,
          align: TextAlign.end,
        ),
      ],
    );
  }

  Widget _cell(
    String text,
    bool isActive,
    ColorScheme cs, {
    TextAlign align = TextAlign.center,
  }) {
    return Expanded(
      child: Text(
        text,
        textAlign: align,
        style: AppTextStyles.bodyMedium(
          weight: isActive ? FontWeight.w700 : FontWeight.w500,
          color: isActive ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
