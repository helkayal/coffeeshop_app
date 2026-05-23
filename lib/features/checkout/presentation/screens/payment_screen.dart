import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../widgets/credit_card_sheet.dart';
import '../widgets/payment_option.dart';
import '../widgets/payment_order_summary.dart';
import '../widgets/wallet_sheet.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _usePoints = false;
  String _paymentMethod = '';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Stack(children: [
      SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 140),
      child: Column(children: [
        const SizedBox(height: 16),
        Text('checkout.complete_order'.tr(), style: tt.headlineMedium?.copyWith(fontSize: 36, color: cs.onSurface)),
        const SizedBox(height: 8),
        Text('checkout.secure_checkout'.tr(), style: tt.bodySmall),
        const SizedBox(height: 40),
        const PaymentOrderSummary(),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant.withAlpha(128)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('checkout.payment_method'.tr(), style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
            const SizedBox(height: 16),
            PaymentOption(
              icon: Icons.star, label: 'checkout.use_points'.tr(),
              isSelected: _usePoints, isCheckbox: true,
              onTap: () => setState(() => _usePoints = !_usePoints),
            ),
            const SizedBox(height: 12),
            PaymentOption(icon: Icons.payments, label: 'checkout.credit_card'.tr(), isSelected: _paymentMethod == 'card', onTap: () {
              setState(() => _paymentMethod = 'card');
              CreditCardSheet.show(context);
            }),
            const SizedBox(height: 12),
            PaymentOption(icon: Icons.account_balance_wallet, label: 'checkout.wallets'.tr(), isSelected: _paymentMethod == 'wallet', onTap: () {
              setState(() => _paymentMethod = 'wallet');
              WalletSheet.show(context);
            }),
            const SizedBox(height: 12),
            PaymentOption(icon: Icons.contactless, label: 'checkout.apple_pay'.tr(), isSelected: _paymentMethod == 'applepay', onTap: () => setState(() => _paymentMethod = 'applepay')),
          ]),
        ),
      ]),
    ),
    Positioned(
      left: 0, right: 0, bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [cs.surface.withAlpha(0), cs.surface],
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.read<ShellCubit>().clearAndPush(const OrderConfirmationRoute()),
            icon: const Icon(Icons.check_circle, size: 20),
            label: Text('checkout.confirm_order'.tr()),
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ),
      ),
    ),
  ]);
  }
}
