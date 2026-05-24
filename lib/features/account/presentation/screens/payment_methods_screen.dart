import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/add_card_form.dart';
import '../../../../core/widgets/saved_card_tile.dart';
import '../../../../features/checkout/presentation/widgets/payment_option.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selected = 'card_4242';

  void _showAddCardSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: const AddCardForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle(tt, 'payment_methods.saved_cards'.tr()),
        const SizedBox(height: 16),
        SavedCardTile(
          mask: '•••• 4242', expiry: 'Expires 12/28',
          isDefault: _selected == 'card_4242',
          onTap: () => setState(() => _selected = 'card_4242'),
        ),
        const SizedBox(height: 8),
        SavedCardTile(
          mask: '•••• 8371', expiry: 'Expires 06/27',
          isDefault: _selected == 'card_8371',
          onTap: () => setState(() => _selected = 'card_8371'),
        ),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _showAddCardSheet, icon: const Icon(Icons.add, size: 18), label: Text('credit_card.add_new_card'.tr()))),
        const SizedBox(height: 40),
        _sectionTitle(tt, 'payment_methods.other_methods'.tr()),
        const SizedBox(height: 16),
        PaymentOption(icon: Icons.account_balance_wallet, label: 'checkout.wallets'.tr(), isSelected: _selected == 'wallet', showDefaultBadge: true, onTap: () => setState(() => _selected = 'wallet')),
        const SizedBox(height: 12),
        PaymentOption(icon: Icons.contactless, label: 'checkout.apple_pay'.tr(), isSelected: _selected == 'applepay', showDefaultBadge: true, onTap: () => setState(() => _selected = 'applepay')),
      ]),
    );
  }

  Widget _sectionTitle(TextTheme tt, String text) {
    return Text(text, style: tt.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700));
  }
}
