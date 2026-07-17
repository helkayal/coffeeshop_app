import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/saved_card_tile.dart';
import '../../../../features/checkout/presentation/widgets/payment_option.dart';
import '../../../../features/checkout/presentation/widgets/wallet_sheet.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _api = sl<ApiService>();
  List<Map<String, dynamic>> _cards = [];
  String _selected = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _api.get(ApiConstants.paymentMethods);
      if (mounted) {
        setState(() {
          _cards = List<Map<String, dynamic>>.from(data as List);
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addCard({
    required String cardLast4,
    required String expiryMonth,
    required String expiryYear,
    required String cardholderName,
  }) async {
    try {
      var year = int.parse(expiryYear);
      if (year < 100) year += 2000;

      await _api.post(ApiConstants.paymentMethods, data: {
        'card_last4': cardLast4,
        'expiry_month': int.parse(expiryMonth),
        'expiry_year': year,
        'card_brand': 'visa',
        'cardholder_name': cardholderName,
      });
      await _load();
    } catch (_) {}
  }

  Future<void> _deleteCard(String id) async {
    try {
      await _api.delete('${ApiConstants.paymentMethods}/$id');
      await _load();
    } catch (_) {}
  }

  Future<void> _setDefault(String id) async {
    try {
      await _api.patch('${ApiConstants.paymentMethods}/$id');
      await _load();
    } catch (_) {}
  }

  void _showAddCardSheet() {
    final last4Ctrl = TextEditingController();
    final monthCtrl = TextEditingController();
    final yearCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

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
            Text('credit_card.add_new_card'.tr(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            AppTextField(
              controller: last4Ctrl,
              label: 'credit_card.card_number'.tr(),
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.credit_card),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: AppTextField(controller: monthCtrl, label: 'Month')),
              const SizedBox(width: 12),
              Expanded(child: AppTextField(controller: yearCtrl, label: 'Year')),
            ]),
            const SizedBox(height: 12),
            AppTextField(
              controller: nameCtrl,
              label: 'credit_card.name_on_card'.tr(),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final number = last4Ctrl.text.replaceAll(RegExp(r'\s+'), '');
                  if (number.length >= 4) {
                    Navigator.pop(context);
                    _addCard(
                      cardLast4: number.substring(number.length - 4),
                      expiryMonth: monthCtrl.text,
                      expiryYear: yearCtrl.text,
                      cardholderName: nameCtrl.text,
                    );
                  }
                },
                child: Text('credit_card.save_card'.tr()),
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
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionTitle(tt, 'payment_methods.saved_cards'.tr()),
        const SizedBox(height: 16),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_cards.isEmpty)
          Text('No saved cards', style: tt.bodySmall)
        else
          ..._cards.map((card) {
            final cardId = card['id'] as String;
            final selected = _selected == cardId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SavedCardTile(
                mask: '•••• ${card['card_last4']}',
                expiry: 'Expires ${card['expiry_month']}/${card['expiry_year']}',
                isDefault: selected,
                onTap: () {
                  if (selected) {
                    setState(() => _selected = '');
                  } else {
                    setState(() => _selected = cardId);
                    _setDefault(cardId);
                  }
                },
              ),
            );
          }),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showAddCardSheet,
            icon: const Icon(Icons.add, size: 18),
            label: Text('credit_card.add_new_card'.tr()),
          ),
        ),
        if (_selected.isNotEmpty &&
            _selected != 'wallet' &&
            _selected != 'applepay') ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _deleteCard(_selected);
                _selected = '';
              },
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Remove selected card'),
              style: OutlinedButton.styleFrom(foregroundColor: cs.error),
            ),
          ),
        ],
        const SizedBox(height: 40),
        _sectionTitle(tt, 'payment_methods.other_methods'.tr()),
        const SizedBox(height: 16),
        PaymentOption(
          icon: Icons.account_balance_wallet,
          label: 'checkout.wallets'.tr(),
          isSelected: _selected == 'wallet',
          showDefaultBadge: true,
          onTap: () async {
            await WalletSheet.show(context);
            if (mounted) setState(() => _selected = 'wallet');
          },
        ),
        const SizedBox(height: 12),
        PaymentOption(
          icon: Icons.contactless,
          label: 'checkout.apple_pay'.tr(),
          isSelected: _selected == 'applepay',
          showDefaultBadge: true,
          onTap: () => setState(() => _selected = 'applepay'),
        ),
      ]),
    ),
  );
  }

  Widget _sectionTitle(TextTheme tt, String text) {
    return Text(text,
        style: tt.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700));
  }
}
