import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/order.dart';
import 'order_item_row.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final dateStr = '${order.createdAt.day} ${_month(order.createdAt.month)} ${order.createdAt.year}';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(dateStr, style: tt.labelLarge?.copyWith(color: cs.secondary)),
            const SizedBox(height: 4),
            Text('Order #${order.id}',
                style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$${order.total.toStringAsFixed(2)}',
                style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600, color: cs.primary)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4)),
              child: Text(order.status,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            ),
          ]),
        ]),
        const SizedBox(height: 16),
        ...order.items.map((item) => OrderItemRow(item: item)),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.receipt, size: 16, color: cs.primary),
            label: Text('orders_screen.receipt'.tr(),
                style: tt.labelLarge?.copyWith(color: cs.primary)),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.replay, size: 16, color: cs.primary),
            label: Text('orders_screen.reorder'.tr(),
                style: tt.labelLarge?.copyWith(color: cs.primary)),
          ),
        ]),
      ]),
    );
  }

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}
