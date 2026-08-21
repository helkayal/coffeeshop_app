import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../checkout/domain/entities/cart_item.dart';
import '../../../checkout/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/order.dart';
import 'order_card_actions.dart';
import 'order_card_header.dart';
import 'order_item_row.dart';
import 'order_receipt_dialog.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateStr = DateFormat.yMMMd(
      context.locale.toString(),
    ).format(order.createdAt);
    final shortId = order.id.length > 8
        ? '#${order.id.substring(0, 8).toUpperCase()}'
        : '#${order.id}';

    return Container(
      padding: AppInsets.a24,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderCardHeader(
            dateStr: dateStr,
            shortId: shortId,
            total: order.total,
            status: order.status,
          ),
          AppSpacing.v16,
          ...order.items.map((item) => OrderItemRow(item: item)),
          OrderCardActions(
            onReceipt: () => _showReceipt(context),
            onReorder: () => _reorder(context),
          ),
        ],
      ),
    );
  }

  void _showReceipt(BuildContext context) {
    OrderReceiptDialog.show(context, order);
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
}
