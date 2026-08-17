import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/order_item.dart';

class OrderItemRow extends StatelessWidget {
  final OrderItem item;
  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: AppInsets.b16,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: cs.surfaceContainerHighest,
            ),
            child: Icon(Icons.coffee, size: 20, color: cs.onSurfaceVariant),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                ),
                AppSpacing.v2,
                Text(
                  'common.price'.tr(
                    namedArgs: {'amount': item.price.toStringAsFixed(2)},
                  ),
                  style: tt.bodySmall?.copyWith(color: cs.secondary),
                ),
              ],
            ),
          ),
          Text(
            'common.quantity'.tr(
              namedArgs: {'quantity': item.quantity.toString()},
            ),
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
