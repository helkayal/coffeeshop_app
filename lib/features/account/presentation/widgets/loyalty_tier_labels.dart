import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoyaltyTierLabels extends StatelessWidget {
  final int selectedTierIndex;

  const LoyaltyTierLabels({super.key, required this.selectedTierIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        _cell(
          'loyalty.blue'.tr(),
          selectedTierIndex == 0,
          cs,
          tt,
          align: TextAlign.start,
        ),
        _cell('loyalty.silver'.tr(), selectedTierIndex == 1, cs, tt),
        _cell('loyalty.gold'.tr(), selectedTierIndex == 2, cs, tt),
        _cell(
          'loyalty.platinum'.tr(),
          selectedTierIndex == 3,
          cs,
          tt,
          align: TextAlign.end,
        ),
      ],
    );
  }

  Widget _cell(
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
        style: tt.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          color: isActive ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
