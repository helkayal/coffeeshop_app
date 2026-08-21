import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/wallet_transaction.dart';
import 'wallet_transaction_tile.dart';

class WalletTransactionsSection extends StatelessWidget {
  final List<WalletTransaction> transactions;

  const WalletTransactionsSection({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          'wallet.transactions'.tr(),
          style: AppTextStyles.subtitle(
            weight: FontWeight.w700,
            color: cs.onSurface,
          ).copyWith(height: 1.3),
        ),
        AppSpacing.v16,
        if (transactions.isEmpty)
          Text('wallet.no_transactions'.tr(), style: tt.bodySmall)
        else
          ...transactions.map((transaction) {
            final isCredit = transaction.isCredit;
            final desc = switch (transaction.type) {
              WalletTransactionType.topUp => 'wallet.topup'.tr(),
              WalletTransactionType.purchase => 'wallet.purchase'.tr(),
              WalletTransactionType.refund => 'wallet.refund'.tr(),
              WalletTransactionType.unknown =>
                'wallet.unknown_transaction'.tr(),
            };
            return WalletTransactionTile(
              icon: isCredit ? Icons.add_circle : Icons.remove_circle,
              label: desc,
              amount: 'common.price'.tr(
                namedArgs: {
                  'amount':
                      '${isCredit ? '+' : '-'}${transaction.amount.toStringAsFixed(2)}',
                },
              ),
              color: isCredit ? cs.primary : cs.error,
            );
          }),
      ],
    );
  }
}
