import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'order_item_row.dart';
import 'order_line_item.dart';

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String date;
  final String total;
  final String status;
  final List<OrderLineItem> items;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.date,
    required this.total,
    required this.status,
    required this.items,
  });

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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(date, style: tt.labelLarge?.copyWith(color: cs.secondary)),
            const SizedBox(height: 4),
            Text(orderNumber,
                style: tt.headlineMedium
                    ?.copyWith(fontSize: 20, color: cs.onSurface)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(total,
                style: tt.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600, color: cs.primary)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4)),
              child: Text(status,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
            ),
          ]),
        ]),
        const SizedBox(height: 16),
        ...items.map((item) => OrderItemRow(item: item)),
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
}

