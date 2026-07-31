import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/profile_cubit.dart';

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
          final bal = wallet['balance'];
          _balance = bal is double
              ? bal
              : double.tryParse(bal?.toString() ?? '0') ?? 0;
          _transactions = List<Map<String, dynamic>>.from(txns as List);
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _topUp(double amount) async {
    try {
      await _api.post(ApiConstants.walletTopup, data: {'amount': amount});
      await _load();
      if (mounted) {
        context.read<ProfileCubit>().refreshLoyalty();
        AppSnackBar.show(context, 'Wallet topped up successfully',
            type: SnackBarType.success);
      }

    } catch (_) {
      if (mounted) {
        AppSnackBar.show(context, 'Top-up failed', type: SnackBarType.error);
      }
    }
  }

  void _showTopUpSheet() {
    final amountCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48, height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant.withAlpha(128),
                borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Text('wallet.top_up'.tr(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            AppTextField(
              controller: amountCtrl,
              label: 'Amount (EGP)',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.monetization_on_outlined),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final amount = double.tryParse(amountCtrl.text) ?? 0;
                  if (amount > 0) {
                    Navigator.pop(context);
                    _topUp(amount);
                  }
                },
                child: Text('wallet.add'.tr()),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
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
            onPressed: _showTopUpSheet,
            icon: const Icon(Icons.add, size: 18),
            label: Text('wallet.top_up'.tr()),
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
