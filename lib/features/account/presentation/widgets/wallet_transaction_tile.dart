import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class WalletTransactionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color color;

  const WalletTransactionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: AppInsets.a16,
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          AppSpacing.h12,
          Expanded(
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(color: cs.onSurface),
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.bodyLarge(
              weight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
