import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/cart_item.dart';

class PaymentOrderSummary extends StatelessWidget {
  final List<CartItem> items;
  final double total;

  const PaymentOrderSummary({
    super.key,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'checkout.order_summary'.tr(),
            style: tt.headlineMedium?.copyWith(
              fontSize: 24,
              color: cs.onSurface,
            ),
          ),
          AppSpacing.v16,
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s12),
              child: _OrderLine(
                imagePath: item.imagePath,
                name: item.name,
                desc: item.variant.isNotEmpty ? item.variant : item.name,
                price: 'common.price'.tr(
                  namedArgs: {'amount': item.total.toStringAsFixed(2)},
                ),
              ),
            ),
          ),
          AppSpacing.v8,
          Divider(color: cs.outlineVariant.withAlpha(128)),
          AppSpacing.v16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout.total'.tr(),
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              Text(
                'common.price'.tr(
                  namedArgs: {'amount': total.toStringAsFixed(2)},
                ),
                style: tt.headlineMedium?.copyWith(
                  fontSize: 24,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderLine extends StatelessWidget {
  final String imagePath;
  final String name;
  final String desc;
  final String price;

  const _OrderLine({
    required this.imagePath,
    required this.name,
    required this.desc,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            imagePath,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.coffee, color: cs.primary, size: 24),
            ),
          ),
        ),
        AppSpacing.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
              if (desc.isNotEmpty) Text(desc, style: tt.bodySmall),
            ],
          ),
        ),
        Text(
          price,
          style: tt.headlineMedium?.copyWith(fontSize: 18, color: cs.onSurface),
        ),
      ],
    );
  }
}
