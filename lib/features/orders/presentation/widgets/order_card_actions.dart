import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class OrderCardActions extends StatelessWidget {
  final VoidCallback onReceipt;
  final VoidCallback onReorder;

  const OrderCardActions({
    super.key,
    required this.onReceipt,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: onReceipt,
          icon: Icon(Icons.receipt, size: 16, color: cs.primary),
          label: Text(
            'orders_screen.receipt'.tr(),
            style: tt.labelLarge?.copyWith(color: cs.primary),
          ),
        ),
        AppSpacing.h12,
        TextButton.icon(
          onPressed: onReorder,
          icon: Icon(Icons.replay, size: 16, color: cs.primary),
          label: Text(
            'orders_screen.reorder'.tr(),
            style: tt.labelLarge?.copyWith(color: cs.primary),
          ),
        ),
      ],
    );
  }
}
