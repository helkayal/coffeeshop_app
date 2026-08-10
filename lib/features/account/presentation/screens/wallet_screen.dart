import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/network_info_service.dart';
import '../../../../core/services/service_locator.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/package_selection_sheet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _api = sl<ApiService>();
  double _balance = 0;
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final wallet = await _api.get(ApiConstants.wallet);
      final txns = await _api.get(ApiConstants.walletTransactions);
      if (mounted) {
        setState(() {
          final bal = wallet['coffee_cash'] ?? wallet['balance'];
          _balance = bal is double
              ? bal
              : double.tryParse(bal?.toString() ?? '0') ?? 0;
          _transactions = List<Map<String, dynamic>>.from(txns as List);
          _loading = false;
        });
      }
    } on ConnectionException catch (_) {
      if (mounted) {
        sl<ConnectivityCubit>().markOffline(ConnectionStatus.serverUnreachable);
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _showPackageSheet() async {
    final result = await PackageSelectionSheet.show(context);
    if (result != null && mounted) {
      try {
        context.read<ProfileCubit>().loadProfile();
      } catch (_) {}
      await _load();
    }
  }

  void _reloadAfterReconnect() {
    if (!mounted) return;
    setState(() => _loading = true);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocListener<ConnectivityCubit, ConnectivityState>(
      bloc: sl<ConnectivityCubit>(),
      listener: (_, state) {
        if (state is ConnectivityOnline) _reloadAfterReconnect();
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
            Text('wallet.current_balance'.tr(),
                style: tt.labelLarge?.copyWith(
                    color: cs.onSurfaceVariant, letterSpacing: 2, fontSize: 10)),
            const SizedBox(height: 8),
            Text('${_balance.toStringAsFixed(0)} EGP',
                style: tt.headlineMedium?.copyWith(
                    fontSize: 36, fontWeight: FontWeight.w900, color: cs.onSurface)),
          ]),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _showPackageSheet,
            icon: const Icon(Icons.stars, size: 18),
            label: Text('Buy Wallet Package'),
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ),
        const SizedBox(height: 48),
        _sectionTitle(tt, 'wallet.transactions'.tr()),
        const SizedBox(height: 16),
        if (_transactions.isEmpty)
          Text('No transactions yet', style: tt.bodySmall)
        else
          ..._transactions.map((t) {
            final type = t['type'] as String? ?? '';
            final isCredit = type == 'top_up' || type == 'refund';
            final desc = type == 'top_up'
                ? 'wallet.topup'.tr()
                : type == 'purchase'
                    ? 'wallet.purchase'.tr()
                    : type == 'refund'
                        ? 'Refund'
                        : type;
            return _txnTile(
              tt, cs,
              isCredit ? Icons.add_circle : Icons.remove_circle,
              desc,
              '${isCredit ? '+' : '-'}${t['amount']} EGP',
              isCredit ? cs.primary : cs.error,
            );
          }),
      ]),
    ),
    ),
  );
  }

  Widget _txnTile(TextTheme tt, ColorScheme cs, IconData icon,
      String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
            child:
                Text(label, style: tt.bodyMedium?.copyWith(color: cs.onSurface))),
        Text(amount,
            style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }

  Widget _sectionTitle(TextTheme tt, String text) {
    return Text(text,
        style: tt.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700));
  }
}
