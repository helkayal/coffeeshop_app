import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'credit_card_sheet.dart';
import 'payment_option.dart';
import 'wallet_sheet.dart';

/// Reusable payment method selector used in both [PaymentScreen]
/// and [WalletScreen]. Manages its own selection state internally.
///
/// [onChanged] is fired whenever the user changes their selection,
/// giving the parent the current values without owning the state.
class PaymentMethodSelector extends StatefulWidget {
  final void Function(bool usePoints, String paymentMethod)? onChanged;

  const PaymentMethodSelector({super.key, this.onChanged});

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  bool _usePoints = false;
  String _paymentMethod = '';

  void _setMethod(String method) {
    setState(() => _paymentMethod = method);
    widget.onChanged?.call(_usePoints, method);
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
          label: 'checkout.use_points'.tr(),
          isSelected: _usePoints,
          isCheckbox: true,
          onTap: _togglePoints,
        ),
        const SizedBox(height: 12),
        PaymentOption(
          icon: Icons.payments,
          label: 'checkout.credit_card'.tr(),
          isSelected: _paymentMethod == 'card',
          onTap: () {
            _setMethod('card');
            CreditCardSheet.show(context);
          },
        ),
        const SizedBox(height: 12),
        PaymentOption(
          icon: Icons.account_balance_wallet,
          label: 'checkout.wallets'.tr(),
          isSelected: _paymentMethod == 'wallet',
          onTap: () {
            _setMethod('wallet');
            WalletSheet.show(context);
          },
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
