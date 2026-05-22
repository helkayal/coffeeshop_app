import 'package:flutter/material.dart';

import '../../domain/entities/order_item.dart';

class OrderItemRow extends StatelessWidget {
  final OrderItem item;
  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: cs.surfaceContainerHighest,
          ),
          child: Icon(Icons.coffee, size: 20, color: cs.onSurfaceVariant),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
            const SizedBox(height: 2),
            Text('\$${item.price.toStringAsFixed(2)}',
                style: tt.bodySmall?.copyWith(color: cs.secondary)),
          ]),
        ),
        Text('x${item.quantity}',
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
      ]),
    );
  }
}
