import 'package:flutter/material.dart';

import '../../../../features/checkout/presentation/screens/cart_screen.dart';

class BottomActionBar extends StatelessWidget {
  final String total;

  const BottomActionBar({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface.withAlpha(242),
        border: Border(top: BorderSide(color: cs.outlineVariant.withAlpha(128))),
      ),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Total Estimate',
              style: tt.labelLarge?.copyWith(fontSize: 10, color: cs.onSurfaceVariant, letterSpacing: 2)),
          Text(total,
              style: tt.headlineMedium?.copyWith(fontSize: 30, color: cs.onSurface)),
        ]),
        const Spacer(),
        IconButton.filled(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
          style: IconButton.styleFrom(
              backgroundColor: cs.surfaceContainerHighest, foregroundColor: cs.primary),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const CartScreen())),
          icon: const Icon(Icons.check_circle, size: 18),
          label: Text('Complete Order',
              style: tt.labelLarge?.copyWith(color: cs.onPrimary)),
        ),
      ]),
    );
  }
}
