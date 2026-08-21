import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/cart_item.dart';

class OrderReceiptCard extends StatelessWidget {
  final String orderId;
  final List<CartItem> items;
  final double total;

  const OrderReceiptCard({
    super.key,
    required this.orderId,
    required this.items,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: AppInsets.a24,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'checkout.receipt'.tr(),
              style: AppTextStyles.subtitle(color: cs.onSurface)
                  .copyWith(height: 1.3),
            ),
          ),
          AppSpacing.v20,
          _receiptBlock(tt, cs, 'checkout.order_number'.tr(), orderId),
          AppSpacing.v12,
          _receiptBlock(
            tt,
            cs,
            'checkout.date'.tr(),
            DateFormat.yMd(
              context.locale.toString(),
            ).format(DateTime.now()),
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
          style: AppTextStyles.bodyMedium(
            weight: FontWeight.w600,
            color: cs.onSurface,
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
          style: AppTextStyles.bodyMedium(
            weight: FontWeight.w500,
            color: cs.onSurface,
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
      ],
    );
  }
}
