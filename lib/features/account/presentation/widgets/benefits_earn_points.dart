import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BenefitsEarnPoints extends StatelessWidget {
  const BenefitsEarnPoints({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(16), border: Border.all(color: cs.outlineVariant.withAlpha(128))),
      child: Column(children: [
        _earnRow(Icons.shopping_bag, 'benefits.earn_purchase'.tr(), tt, cs),
        const SizedBox(height: 12), Divider(color: cs.outlineVariant.withAlpha(77)), const SizedBox(height: 12),
        _earnRow(Icons.reviews, 'benefits.earn_review'.tr(), tt, cs),
        const SizedBox(height: 12), Divider(color: cs.outlineVariant.withAlpha(77)), const SizedBox(height: 12),
        _earnRow(Icons.share, 'benefits.earn_referral'.tr(), tt, cs),
        const SizedBox(height: 12), Divider(color: cs.outlineVariant.withAlpha(77)), const SizedBox(height: 12),
        _earnRow(Icons.card_giftcard, 'benefits.earn_birthday'.tr(), tt, cs),
      ]),
    );
  }

  Widget _earnRow(IconData icon, String text, TextTheme tt, ColorScheme cs) {
    return Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: cs.primary.withAlpha(26), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: cs.primary, size: 20)),
      const SizedBox(width: 16),
      Expanded(child: Text(text, style: tt.bodyMedium?.copyWith(color: cs.onSurface))),
    ]);
  }
}
