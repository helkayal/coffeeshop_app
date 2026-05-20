import 'package:flutter/material.dart';

class PaymentOrderSummary extends StatelessWidget {
  const PaymentOrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Order Summary', style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
        const SizedBox(height: 16),
        _OrderLine(icon: Icons.coffee, name: 'Ethiopian Yirgacheffe', desc: 'Pour over, Light roast', price: r'$8.00'),
        const SizedBox(height: 16),
        _OrderLine(icon: Icons.bakery_dining, name: 'Almond Croissant', desc: 'Warmed', price: r'$6.50'),
        const SizedBox(height: 16),
        Divider(color: cs.outlineVariant.withAlpha(128)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total', style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
          Text(r'$14.50', style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.primary)),
        ]),
      ]),
    );
  }
}

class _OrderLine extends StatelessWidget {
  final IconData icon;
  final String name;
  final String desc;
  final String price;

  const _OrderLine({required this.icon, required this.name, required this.desc, required this.price});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(children: [
      Container(
        width: 48, height: 48,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: cs.surfaceContainerHighest),
        child: Icon(icon, color: cs.primary, size: 24),
      ),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
        Text(desc, style: tt.bodySmall),
      ])),
      Text(price, style: tt.headlineMedium?.copyWith(fontSize: 18, color: cs.onSurface)),
    ]);
  }
}
