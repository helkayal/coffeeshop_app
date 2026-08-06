import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../features/checkout/presentation/widgets/payment_option.dart';
import '../../../../features/checkout/presentation/widgets/wallet_sheet.dart';
import '../widgets/add_card_form_sheet.dart';
import '../widgets/saved_card_tile.dart';

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
      builder: (ctx) => AddCardFormSheet(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                if (mounted) setState(() => _selected = 'applepay');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(TextTheme tt, String text) {
    return Text(
      text,
      style: tt.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }
}
