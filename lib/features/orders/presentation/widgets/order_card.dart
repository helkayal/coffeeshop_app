import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../checkout/domain/entities/cart_item.dart';
import '../../../checkout/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/order.dart';
import 'order_item_row.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final dateStr =
        '${order.createdAt.day} ${_month(order.createdAt.month)} ${order.createdAt.year}';
    final shortId = order.id.length > 8
        ? '#${order.id.substring(0, 8).toUpperCase()}'
        : '#${order.id}';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(dateStr, style: tt.labelLarge?.copyWith(color: cs.secondary)),
              const SizedBox(height: 4),
              Text(shortId,
                  style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${order.total.toStringAsFixed(2)} EGP',
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
            onPressed: () => _showReceipt(context),
            icon: Icon(Icons.receipt, size: 16, color: cs.primary),
            label: Text('orders_screen.receipt'.tr(),
                style: tt.labelLarge?.copyWith(color: cs.primary)),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: () => _reorder(context),
            icon: Icon(Icons.replay, size: 16, color: cs.primary),
            label: Text('orders_screen.reorder'.tr(),
                style: tt.labelLarge?.copyWith(color: cs.primary)),
          ),
        ]),
      ]),
    );
  }

  void _showReceipt(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('orders_screen.receipt'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _receiptLine(context, 'Order', order.id.substring(0, 8).toUpperCase()),
            const SizedBox(height: 4),
            _receiptLine(context, 'Date',
                '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}'),
            const Divider(),
            ...order.items.map((item) => _receiptLine(
                  context,
                  item.name,
                  '${item.price.toStringAsFixed(2)} EGP x${item.quantity}',
                )),
            const Divider(),
            _receiptLine(context, 'Total',
                '${order.total.toStringAsFixed(2)} EGP',
                bold: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _receiptLine(BuildContext context, String label, String value, {bool bold = false}) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(child: Text(label, style: tt.bodySmall)),
      const SizedBox(width: 12),
      Flexible(
        child: Text(value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: (bold ? tt.bodyLarge : tt.bodyMedium)?.copyWith(
                color: cs.onSurface,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
      ),
    ]);
  }

  void _reorder(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    for (final item in order.items) {
      final variantParts = item.selections
          .map((s) => s['modifier_name'] as String? ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      final ids = item.selections
          .map((s) => s['modifier_id'] as String? ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      final variant = variantParts.isNotEmpty
          ? variantParts.join(' • ')
          : item.name;
      final cartItem = CartItem(
        id: '${order.id}_${item.menuItemId}_${DateTime.now().millisecondsSinceEpoch}',
        productId: item.menuItemId,
        name: item.name,
        imagePath: '',
        variant: variant,
        unitPrice: item.price,
        quantity: item.quantity,
        modifierIds: ids,
      );
      cartCubit.addItem(cartItem);
    }
    context.read<ShellCubit>().pushSecondary(const CartRoute());
  }

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}
