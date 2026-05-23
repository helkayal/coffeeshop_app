import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../config/app_config.dart';

class BenefitsAllTiers extends StatelessWidget {
  final int currentIndex;

  const BenefitsAllTiers({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final tiers = [
      _TierInfo('loyalty.blue'.tr(), AppConfig.tier1Color, ['benefits.discount'.tr(), 'benefits.birthday'.tr()]),
      _TierInfo('loyalty.silver'.tr(), AppConfig.tier2Color, ['benefits.discount'.tr(), 'benefits.birthday'.tr(), 'benefits.priority'.tr()]),
      _TierInfo('loyalty.gold'.tr(), AppConfig.tier3Color, ['benefits.discount'.tr(), 'benefits.birthday'.tr(), 'benefits.priority'.tr(), 'benefits.free_drink'.tr()]),
      _TierInfo('loyalty.platinum'.tr(), AppConfig.tier4Color, ['benefits.discount'.tr(), 'benefits.birthday'.tr(), 'benefits.priority'.tr(), 'benefits.free_drink'.tr(), 'benefits.exclusive'.tr()]),
    ];

    return Column(
      children: tiers.asMap().entries.map((e) {
        final i = e.key;
        final t = e.value;
        final isCurrent = i == currentIndex;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isCurrent ? t.color.withAlpha(153) : cs.outlineVariant.withAlpha(77), width: isCurrent ? 2 : 1),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 16, height: 16, decoration: BoxDecoration(color: t.color, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Text(t.name, style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: cs.onSurface)),
              const Spacer(),
              if (isCurrent) Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: t.color.withAlpha(26), borderRadius: BorderRadius.circular(8)),
                child: Text('benefits.current'.tr(), style: tt.bodySmall?.copyWith(color: t.color, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 12),
            ...t.benefits.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(children: [
                Icon(Icons.check_circle, size: 16, color: t.color),
                const SizedBox(width: 8),
                Text(b, style: tt.bodySmall),
              ]),
            )),
          ]),
        );
      }).toList(),
    );
  }
}

class _TierInfo {
  final String name;
  final Color color;
  final List<String> benefits;

  const _TierInfo(this.name, this.color, this.benefits);
}
