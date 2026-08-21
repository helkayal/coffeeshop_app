import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class OrderCardHeader extends StatelessWidget {
  final String dateStr;
  final String shortId;
  final double total;
  final String status;

  const OrderCardHeader({
    super.key,
    required this.dateStr,
    required this.shortId,
    required this.total,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateStr,
                style: tt.labelLarge?.copyWith(color: cs.secondary),
              ),
              AppSpacing.v4,
              Text(
                shortId,
                style: AppTextStyles.subtitle(color: cs.onSurface)
                    .copyWith(height: 1.3),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'common.price'.tr(
                namedArgs: {'amount': total.toStringAsFixed(2)},
              ),
              style: AppTextStyles.bodyLarge(
                weight: FontWeight.w600,
                color: cs.primary,
              ),
            ),
            AppSpacing.v4,
            Container(
              padding: AppInsets.h8v4,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _localizedStatus(status),
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _localizedStatus(String status) {
    final key = switch (status.toLowerCase()) {
      'pending' => 'pending',
      'accepted' => 'accepted',
      'preparing' => 'preparing',
      'ready_for_pickup' => 'ready_for_pickup',
      'completed' => 'completed',
      'cancelled' => 'cancelled',
      _ => 'unknown',
    };
    return 'orders_screen.status.$key'.tr();
  }
}
