import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final state = context.read<CartCubit>().state;
    final items = state is OrderPlaced ? state.items : <CartItem>[];
    final total = state is OrderPlaced ? state.total : 0.0;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
        child: Column(children: [
        Icon(Icons.check_circle, size: 72, color: cs.primary),
        const SizedBox(height: 24),
        Text('checkout.order_complete'.tr(),
            style: tt.headlineMedium?.copyWith(
                fontSize: 28, fontWeight: FontWeight.w700, color: cs.onSurface)),
        const SizedBox(height: 8),
        Text('checkout.order_complete_sub'.tr(), style: tt.bodySmall),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withAlpha(128)),
          ),
          child: Column(children: [
            Text('checkout.receipt'.tr(),
                style: tt.headlineMedium?.copyWith(
                    fontSize: 20, color: cs.onSurface)),
            const SizedBox(height: 20),
            _receiptBlock(tt, cs, 'checkout.order_number'.tr(), orderId),
            const SizedBox(height: 12),
            _receiptBlock(tt, cs, 'checkout.date'.tr(), _formatDate(DateTime.now())),
            const SizedBox(height: 12),
            Divider(color: cs.outlineVariant.withAlpha(128)),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _receiptItem(tt, cs, item),
            )),
            const SizedBox(height: 12),
            Divider(color: cs.outlineVariant.withAlpha(128)),
            const SizedBox(height: 12),
            _receiptRow(tt, cs, 'checkout.total'.tr(),
                '\$${total.toStringAsFixed(2)}',
                bold: true),
          ]),
        ),
      ]),
      ),
    );
  }

  Widget _receiptItem(TextTheme tt, ColorScheme cs, CartItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            item.imagePath,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.coffee, size: 20, color: cs.primary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
              if (item.variant.isNotEmpty)
                Text(item.variant, style: tt.bodySmall),
            ],
          ),
        ),
        Text('x${item.quantity}', style: tt.bodySmall),
        const SizedBox(width: 12),
        Text(
          '\$${item.total.toStringAsFixed(2)}',
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _receiptBlock(TextTheme tt, ColorScheme cs, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tt.bodySmall),
        const SizedBox(height: 4),
        Text(value,
            style: tt.bodyMedium?.copyWith(
                color: cs.onSurface, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _receiptRow(TextTheme tt, ColorScheme cs, String label, String value,
      {bool bold = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: tt.bodySmall),
      Text(value,
          style: (bold ? tt.bodyLarge : tt.bodyMedium)?.copyWith(
              color: cs.onSurface,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
    ]);
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }
}
