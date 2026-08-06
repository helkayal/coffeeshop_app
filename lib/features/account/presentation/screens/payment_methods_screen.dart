import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/saved_card_tile.dart';
import '../../../../features/checkout/presentation/widgets/payment_option.dart';
import '../../../../features/checkout/presentation/widgets/wallet_sheet.dart';

import '../../../../core/services/local_storage_service.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _api = sl<ApiService>();
  final _storage = sl<LocalStorageService>();
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
          final savedMethod = _storage.getDefaultPaymentMethod();
          if (savedMethod != null && savedMethod.isNotEmpty) {
            _selected = savedMethod;
          } else {
            final defaultCard = _cards.firstWhere(
              (c) => c['is_default'] == true,
              orElse: () => <String, dynamic>{},
            );
            _selected = defaultCard['id'] as String? ?? '';
          }
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
      if (_selected == id) {
        await _storage.clearDefaultPaymentMethod();
        _selected = '';
      }
      await _api.delete('${ApiConstants.paymentMethods}/$id');
      await _load();
    } catch (_) {}
  }

  Future<void> _setDefault(String id) async {
    try {
      await _storage.setDefaultPaymentMethod(id);
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
      builder: (ctx) => _AddCardForm(
        last4Ctrl: last4Ctrl,
        monthCtrl: monthCtrl,
        yearCtrl: yearCtrl,
        nameCtrl: nameCtrl,
        onSave: (last4, month, year, name) {
          Navigator.pop(ctx);
          _addCard(
            cardLast4: last4,
            expiryMonth: month,
            expiryYear: year,
            cardholderName: name,
          );
        },
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
                    _storage.clearDefaultPaymentMethod();
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
          showDefaultBadge: _selected == 'wallet',
          onTap: () async {
            await WalletSheet.show(context);
            if (mounted) {
              await _storage.setDefaultPaymentMethod('wallet');
              setState(() => _selected = 'wallet');
            }
          },
        ),
        const SizedBox(height: 12),
        PaymentOption(
          icon: Icons.contactless,
          label: 'checkout.apple_pay'.tr(),
          isSelected: _selected == 'applepay',
          showDefaultBadge: _selected == 'applepay',
          onTap: () async {
            await _storage.setDefaultPaymentMethod('applepay');
          },
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

class _AddCardForm extends StatefulWidget {
  final TextEditingController last4Ctrl;
  final TextEditingController monthCtrl;
  final TextEditingController yearCtrl;
  final TextEditingController nameCtrl;
  final void Function(String last4, String month, String year, String name) onSave;

  const _AddCardForm({
    required this.last4Ctrl,
    required this.monthCtrl,
    required this.yearCtrl,
    required this.nameCtrl,
    required this.onSave,
  });

  @override
  State<_AddCardForm> createState() => _AddCardFormState();
}

class _AddCardFormState extends State<_AddCardForm> {
  String? _error;

  String? _validate() {
    final number =
        widget.last4Ctrl.text.trim().replaceAll(RegExp(r'\s+'), '');
    if (number.length != 16 || int.tryParse(number) == null) {
      return 'Card number must be 16 digits';
    }

    final name = widget.nameCtrl.text.trim();
    if (name.isEmpty) {
      return 'Name on card is required';
    }

    final month = int.tryParse(widget.monthCtrl.text.trim());
    if (month == null || month < 1 || month > 12) {
      return 'Expiry month must be between 1 and 12';
    }

    var year = int.tryParse(widget.yearCtrl.text.trim());
    if (year == null) {
      return 'Expiry year is required';
    }
    if (year < 100) year += 2000;

    final now = DateTime.now();
    final expiryDate = DateTime(year, month + 1, 0);
    final currentMonthEnd = DateTime(now.year, now.month + 1, 0);
    if (expiryDate.isBefore(currentMonthEnd)) {
      return 'Card has expired';
    }

    return null;
  }

  void _submit() {
    final error = _validate();
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    final number =
        widget.last4Ctrl.text.trim().replaceAll(RegExp(r'\s+'), '');
    final last4 = number.substring(number.length - 4);
    var year = int.parse(widget.yearCtrl.text.trim());
    if (year < 100) year += 2000;

    widget.onSave(last4, widget.monthCtrl.text.trim(), year.toString(),
        widget.nameCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant.withAlpha(128),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text('credit_card.add_new_card'.tr(),
              style: tt.headlineMedium?.copyWith(fontSize: 20)),
          const SizedBox(height: 16),
          AppTextField(
            controller: widget.last4Ctrl,
            label: 'credit_card.card_number'.tr(),
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.credit_card),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: AppTextField(
                    controller: widget.monthCtrl, label: 'Month')),
            const SizedBox(width: 12),
            Expanded(
                child: AppTextField(
                    controller: widget.yearCtrl, label: 'Year')),
          ]),
          const SizedBox(height: 12),
          AppTextField(
            controller: widget.nameCtrl,
            label: 'credit_card.name_on_card'.tr(),
            prefixIcon: const Icon(Icons.person_outline),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: tt.bodySmall?.copyWith(color: cs.error)),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: Text('credit_card.save_card'.tr()),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
