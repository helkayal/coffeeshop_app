import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/top_up_sheet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  static const _balance = 250.00;

  void _showTopUpSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const TopUpSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant.withAlpha(128)),
          ),
          child: Column(children: [
            Icon(Icons.account_balance_wallet, size: 48, color: cs.primary),
            const SizedBox(height: 16),
            Text('wallet.current_balance'.tr(), style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant, letterSpacing: 2, fontSize: 10)),
            const SizedBox(height: 8),
            Text('${_balance.toStringAsFixed(0)} EGP', style: tt.headlineMedium?.copyWith(fontSize: 36, fontWeight: FontWeight.w900, color: cs.onSurface)),
          ]),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _showTopUpSheet,
            icon: const Icon(Icons.add, size: 18),
            label: Text('wallet.top_up'.tr()),
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ),
        const SizedBox(height: 48),
        _sectionTitle(tt, 'wallet.transactions'.tr()),
        const SizedBox(height: 16),
        _txnTile(tt, cs, Icons.add_circle, 'wallet.topup'.tr(), '+100 EGP', cs.primary),
        _txnTile(tt, cs, Icons.remove_circle, 'wallet.purchase'.tr(), '-45 EGP', cs.error),
        _txnTile(tt, cs, Icons.add_circle, 'wallet.topup'.tr(), '+200 EGP', cs.primary),
      ]),
    );
  }

  Widget _txnTile(TextTheme tt, ColorScheme cs, IconData icon, String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: cs.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: tt.bodyMedium?.copyWith(color: cs.onSurface))),
        Text(amount, style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }

  Widget _sectionTitle(TextTheme tt, String text) {
    return Text(text, style: tt.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700));
  }
}
