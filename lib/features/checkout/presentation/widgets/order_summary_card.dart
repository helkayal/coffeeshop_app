import 'package:flutter/material.dart';

import '../screens/payment_screen.dart';

class OrderSummaryCard extends StatelessWidget {
  final String subtotal;
  final String shipping;
  final String total;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(77)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: cs.outlineVariant.withAlpha(128)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.edit, size: 18, color: cs.onSurfaceVariant),
              const SizedBox(width: 8),
              Text('Special Instructions', style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
            ]),
            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a note to your order...',
                hintStyle: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 24),
        Text('Summary', style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Subtotal', style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          Text(subtotal, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
        ]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Shipping', style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          Text(shipping, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
        ]),
        const SizedBox(height: 24),
        Divider(color: cs.outlineVariant.withAlpha(128)),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total', style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
          Text(total, style: tt.headlineMedium?.copyWith(fontSize: 30, color: cs.primary)),
        ]),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const PaymentScreen())),
            icon: const Icon(Icons.arrow_forward, size: 20),
            label: const Text('Proceed to Checkout'),
          ),
        ),
      ]),
    );
  }
}
