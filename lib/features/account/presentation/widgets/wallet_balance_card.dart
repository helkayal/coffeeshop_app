import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;

  const WalletBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: AppInsets.a32,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 48,
            color: cs.primary,
          ),
          AppSpacing.v16,
          Text(
            'wallet.current_balance'.tr(),
            style: AppTextStyles.labelMicro(color: cs.onSurfaceVariant)
                .copyWith(letterSpacing: 2, height: 1.0),
          ),
          AppSpacing.v8,
          Text(
            'common.price'.tr(
              namedArgs: {'amount': balance.toStringAsFixed(0)},
            ),
            style: AppTextStyles.display(
              weight: FontWeight.w900,
              color: cs.onSurface,
            ).copyWith(height: 1.3),
          ),
        ],
      ),
    );
  }
}
