import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/connectivity_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/wallet_cubit.dart';
import '../cubit/wallet_state.dart';
import '../widgets/package_selection_sheet.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

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
            : <Map<String, dynamic>>[];

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
  final List<Map<String, dynamic>> transactions;
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
          padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.outlineVariant.withAlpha(128)),
              ),
              child: Column(children: [
                Icon(Icons.account_balance_wallet, size: 48, color: cs.primary),
                const SizedBox(height: 16),
                Text(
                  'wallet.current_balance'.tr(),
                  style: tt.labelLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                    letterSpacing: 2,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${balance.toStringAsFixed(0)} EGP',
                  style: tt.headlineMedium?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onTopUp,
                icon: const Icon(Icons.stars, size: 18),
                label: const Text('Buy Wallet Package'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'wallet.transactions'.tr(),
              style: tt.headlineMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            if (transactions.isEmpty)
              Text('No transactions yet', style: tt.bodySmall)
            else
              ...transactions.map((t) {
                final type = t['type'] as String? ?? '';
                final isCredit = type == 'top_up' || type == 'refund';
                final desc = type == 'top_up'
                    ? 'wallet.topup'.tr()
                    : type == 'purchase'
                        ? 'wallet.purchase'.tr()
                        : type == 'refund'
                            ? 'Refund'
                            : type;
                return _TxnTile(
                  icon: isCredit ? Icons.add_circle : Icons.remove_circle,
                  label: desc,
                  amount: '${isCredit ? '+' : '-'}${t['amount']} EGP',
                  color: isCredit ? cs.primary : cs.error,
                );
              }),
          ]),
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
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
        ),
        Text(
          amount,
          style: tt.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ]),
    );
  }
}
