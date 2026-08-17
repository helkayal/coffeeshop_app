import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
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
    final items = state is OrderResultState ? state.items : <CartItem>[];
    final total = state is OrderResultState ? state.total : 0.0;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        padding: AppInsets.screen,
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 72, color: cs.primary),
            AppSpacing.v24,
            Text(
              'checkout.order_complete'.tr(),
              style: tt.headlineMedium?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            AppSpacing.v8,
            Text('checkout.order_complete_sub'.tr(), style: tt.bodySmall),
            AppSpacing.v40,
            Container(
              padding: AppInsets.a24,
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withAlpha(128)),
              ),
              child: Column(
                children: [
                  Text(
                    'checkout.receipt'.tr(),
                    style: tt.headlineMedium?.copyWith(
                      fontSize: 20,
                      color: cs.onSurface,
                    ),
                  ),
                  AppSpacing.v20,
                  _receiptBlock(tt, cs, 'checkout.order_number'.tr(), orderId),
                  AppSpacing.v12,
                  _receiptBlock(
                    tt,
                    cs,
                    'checkout.date'.tr(),
                    DateFormat.yMd(context.locale.toString()).format(DateTime.now()),
                  ),
                  AppSpacing.v12,
                  Divider(color: cs.outlineVariant.withAlpha(128)),
                  AppSpacing.v12,
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
                      child: _receiptItem(tt, cs, item),
                    ),
                  ),
                  AppSpacing.v12,
                  Divider(color: cs.outlineVariant.withAlpha(128)),
                  AppSpacing.v12,
                  _receiptRow(
                    tt,
                    cs,
                    'checkout.total'.tr(),
                    'common.price'.tr(
                      namedArgs: {'amount': total.toStringAsFixed(2)},
                    ),
                    bold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
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
        AppSpacing.h12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              ),
              if (item.variant.isNotEmpty)
                Text(item.variant, style: tt.bodySmall),
            ],
          ),
        ),
        Text(
          'common.quantity'.tr(
            namedArgs: {'quantity': item.quantity.toString()},
          ),
          style: tt.bodySmall,
        ),
        AppSpacing.h12,
        Text(
          'common.price'.tr(
            namedArgs: {'amount': item.total.toStringAsFixed(2)},
          ),
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _receiptBlock(
    TextTheme tt,
    ColorScheme cs,
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tt.bodySmall),
        AppSpacing.v4,
        Text(
          value,
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _receiptRow(
    TextTheme tt,
    ColorScheme cs,
    String label,
    String value, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: tt.bodySmall),
        Text(
          value,
          style: (bold ? tt.bodyLarge : tt.bodyMedium)?.copyWith(
            color: cs.onSurface,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
