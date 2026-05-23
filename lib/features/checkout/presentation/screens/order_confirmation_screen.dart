import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
      child: Column(children: [
        Icon(Icons.check_circle, size: 72, color: cs.primary),
        const SizedBox(height: 24),
        Text('checkout.order_complete'.tr(), style: tt.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.w700, color: cs.onSurface)),
        const SizedBox(height: 8),
        Text('checkout.order_complete_sub'.tr(), style: tt.bodySmall),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withAlpha(128)),
          ),
          child: Column(children: [
            Text('checkout.receipt'.tr(), style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
            const SizedBox(height: 20),
            _receiptRow(tt, cs, 'checkout.order_number'.tr(), '#ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
            const SizedBox(height: 12),
            _receiptRow(tt, cs, 'checkout.date'.tr(), _formatDate(DateTime.now())),
            const SizedBox(height: 12),
            Divider(color: cs.outlineVariant.withAlpha(128)),
            const SizedBox(height: 12),
            _receiptRow(tt, cs, 'Ethiopian Yirgacheffe', r'$8.00'),
            const SizedBox(height: 8),
            _receiptRow(tt, cs, 'Almond Croissant', r'$6.50'),
            const SizedBox(height: 12),
            Divider(color: cs.outlineVariant.withAlpha(128)),
            const SizedBox(height: 12),
            _receiptRow(tt, cs, 'checkout.total'.tr(), r'$14.50', bold: true),
            const SizedBox(height: 8),
            _receiptRow(tt, cs, 'checkout.payment_method'.tr(), 'Credit Card'),
          ]),
        ),
      ]),
    );
  }

  Widget _receiptRow(TextTheme tt, ColorScheme cs, String label, String value, {bool bold = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: tt.bodySmall),
      Text(value, style: (bold ? tt.bodyLarge : tt.bodyMedium)?.copyWith(
          color: cs.onSurface, fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
    ]);
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }
}
