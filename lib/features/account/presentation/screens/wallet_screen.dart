import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/wallet_cubit.dart';
import '../cubit/wallet_state.dart';
import '../widgets/package_selection_sheet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().loadWallet();
  }

  Future<void> _showPackageSheet(BuildContext context) async {
    final walletCubit = context.read<WalletCubit>();
    walletCubit.loadPackages();
    final result = await PackageSelectionSheet.show(context);
    if (result != null && context.mounted) {
      context.read<ProfileCubit>().loadProfile();
      walletCubit.loadWallet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final isLoading = state is WalletInitial || state is WalletLoading;
        final balance = state is WalletLoaded ? state.balance : 0.0;
        final transactions = state is WalletLoaded
            ? state.transactions
            : <WalletTransaction>[];

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _WalletBody(
          balance: balance,
          transactions: transactions,
          onTopUp: () => _showPackageSheet(context),
        );
      },
    );
  }
}

class _WalletBody extends StatelessWidget {
  final double balance;
  final List<WalletTransaction> transactions;
  final VoidCallback onTopUp;

  const _WalletBody({
    required this.balance,
    required this.transactions,
    required this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocListener<ConnectivityCubit, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityOnline) {
          context.read<WalletCubit>().loadWallet();
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SingleChildScrollView(
          padding: AppInsets.screen,
          child: Column(
            children: [
              Container(
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
                      style: tt.labelLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        letterSpacing: 2,
                        fontSize: 10,
                      ),
                    ),
                    AppSpacing.v8,
                    Text(
                      'common.price'.tr(
                        namedArgs: {'amount': balance.toStringAsFixed(0)},
                      ),
                      style: tt.headlineMedium?.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.v32,
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onTopUp,
                  icon: const Icon(Icons.stars, size: 18),
                  label: Text('wallet.buy_package'.tr()),
                  style: FilledButton.styleFrom(
                    padding: AppInsets.v16,
                  ),
                ),
              ),
              AppSpacing.v48,
              Text(
                'wallet.transactions'.tr(),
                style: tt.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
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
                  return _TxnTile(
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
          ),
        ),
      ),
    );
  }
}

class _TxnTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color color;

  const _TxnTile({
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
            style: tt.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
