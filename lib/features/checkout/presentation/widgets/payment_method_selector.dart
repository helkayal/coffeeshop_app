import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import 'credit_card_sheet.dart';
import 'payment_option.dart';
import 'wallet_sheet.dart';

class PaymentMethodSelector extends StatefulWidget {
  final void Function(bool usePoints, String paymentMethod)? onChanged;

  const PaymentMethodSelector({super.key, this.onChanged});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  final _storage = sl<LocalStorageService>();
  bool _usePoints = true; // Default: use wallet cash first
  String _paymentMethod = '';

  @override
  void initState() {
    super.initState();
    _paymentMethod = _storage.getDefaultPaymentMethod() ?? '';
  }

  void _setMethod(String method) {
    _storage.setDefaultPaymentMethod(method);
    setState(() => _paymentMethod = method);
    widget.onChanged?.call(_usePoints, method);
  }

  Future<void> _openCardSheet() async {
    _setMethod('card');
    await CreditCardSheet.show(context);
    // Always notify parent after sheet closes — cards may have been
    // synced to local storage during the sheet's initState.
    if (mounted) {
      widget.onChanged?.call(_usePoints, _paymentMethod);
    }
  }

  Future<void> _openWalletSheet() async {
    _setMethod('wallet');
    final saved = await WalletSheet.show(context);
    if (saved && mounted) {
      widget.onChanged?.call(_usePoints, _paymentMethod);
    }
  }

  void _togglePoints() {
    setState(() => _usePoints = !_usePoints);
    widget.onChanged?.call(_usePoints, _paymentMethod);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'checkout.payment_method'.tr(),
          style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface),
        ),
        const SizedBox(height: 16),
        PaymentOption(
          icon: Icons.star,
          label: 'Use Coffee Wallet Cash First',
          isSelected: _usePoints,
          isCheckbox: true,
          onTap: _togglePoints,
        ),
        const SizedBox(height: 12),
        PaymentOption(
          icon: Icons.payments,
          label: 'checkout.credit_card'.tr(),
          isSelected: _paymentMethod == 'card',
          onTap: _openCardSheet,
        ),
        const SizedBox(height: 12),
        PaymentOption(
          icon: Icons.account_balance_wallet,
          label: 'checkout.wallets'.tr(),
          isSelected: _paymentMethod == 'wallet',
          onTap: _openWalletSheet,
        ),
        const SizedBox(height: 12),
        PaymentOption(
          icon: Icons.contactless,
          label: 'checkout.apple_pay'.tr(),
          isSelected: _paymentMethod == 'applepay',
          onTap: () => _setMethod('applepay'),
        ),
      ]),
    );
  }
}
