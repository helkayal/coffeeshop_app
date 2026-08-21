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
import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_transactions_section.dart';

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
              WalletBalanceCard(balance: balance),
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
              WalletTransactionsSection(transactions: transactions),
            ],
          ),
        ),
      ),
    );
  }
}
