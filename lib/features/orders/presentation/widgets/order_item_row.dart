import 'package:flutter/material.dart';

import 'order_line_item.dart';

class OrderItemRow extends StatelessWidget {
  final OrderLineItem item;
  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: cs.surfaceContainerHighest,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(item.imagePath, fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: cs.surfaceContainerHighest)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name,
                style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
            const SizedBox(height: 4),
            Text(item.modifiers,
                style: tt.bodySmall?.copyWith(color: cs.secondary)),
          ]),
        ),
        Text(item.quantity,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
      ]),
    );
  }
}
