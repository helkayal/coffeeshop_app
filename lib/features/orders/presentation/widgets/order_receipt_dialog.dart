import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/order.dart';

class OrderReceiptDialog {
  const OrderReceiptDialog._();

  static void show(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('orders_screen.receipt'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _receiptLine(
              context,
              'orders_screen.order'.tr(),
              order.id.substring(0, 8).toUpperCase(),
            ),
            AppSpacing.v4,
            _receiptLine(
              context,
              'orders_screen.date'.tr(),
              DateFormat.yMd(context.locale.toString()).format(order.createdAt),
            ),
            const Divider(),
            ...order.items.map(
              (item) => _receiptLine(
                context,
                item.name,
                'common.price_quantity'.tr(
                  namedArgs: {
                    'price': 'common.price'.tr(
                      namedArgs: {'amount': item.price.toStringAsFixed(2)},
                    ),
                    'quantity': item.quantity.toString(),
                  },
                ),
              ),
            ),
            const Divider(),
            _receiptLine(
              context,
              'orders_screen.total'.tr(),
              'common.price'.tr(
                namedArgs: {'amount': order.total.toStringAsFixed(2)},
              ),
              bold: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.close'.tr()),
          ),
        ],
      ),
    );
  }

  static Widget _receiptLine(
    BuildContext context,
    String label,
    String value, {
    bool bold = false,
  }) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label, style: tt.bodySmall)),
        AppSpacing.h12,
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: bold
                ? AppTextStyles.bodyLarge(
                    weight: FontWeight.w700,
                    color: cs.onSurface,
                  )
                : AppTextStyles.bodyMedium(
                    weight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
          ),
        ),
      ],
    );
  }
}
