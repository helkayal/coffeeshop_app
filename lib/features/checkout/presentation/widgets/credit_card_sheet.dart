import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/saved_card_tile.dart';

class CreditCardSheet extends StatefulWidget {
  const CreditCardSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CreditCardSheet(),
    );
    return result ?? false;
  }

  @override
  State<CreditCardSheet> createState() => _CreditCardSheetState();
}

class _CreditCardSheetState extends State<CreditCardSheet> {
  final _api = sl<ApiService>();
  final _storage = sl<LocalStorageService>();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  List<Map<String, dynamic>> _cards = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    try {
      final data = await _api.get(ApiConstants.paymentMethods);
      if (!mounted) return;
      final cards = List<Map<String, dynamic>>.from(data as List);
      await _storage.setSavedCards(cards);
      setState(() {
        _cards = cards;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      // Fall back to locally cached cards if the API call fails.
      final local = _storage.getSavedCards();
      setState(() {
        _cards = local;
        _loading = false;
        _error = local.isEmpty ? 'credit_card.load_error'.tr() : null;
      });
    }
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveCard() async {
    final number = _numberCtrl.text.trim();
    if (number.length < 4) return;
    final last4 = number.substring(number.length - 4);

    var expiryYear = int.tryParse(_expiryCtrl.text.trim()) ?? 0;
    if (expiryYear < 100) expiryYear += 2000;
    final expiryMonth = int.tryParse(_expiryCtrl.text.trim()) ?? 1;

    final cardData = <String, dynamic>{
      'card_last4': last4,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'card_brand': 'visa',
      'cardholder_name': _nameCtrl.text.trim(),
    };

    try {
      final result = await _api.post(ApiConstants.paymentMethods, data: cardData);
      // Merge the returned card (with its server id) into local storage.
      if (result is Map<String, dynamic>) {
        final cards = _storage.getSavedCards();
        cards.insert(0, result);
        await _storage.setSavedCards(cards);
      }
      await _loadCards();
    } catch (_) {
      // Save locally even if the API call fails, so the user can still pay.
      final cards = _storage.getSavedCards();
      cards.insert(0, cardData);
      await _storage.setSavedCards(cards);
      if (mounted) {
        setState(() => _cards = cards);
      }
    }

    _numberCtrl.clear();
    _expiryCtrl.clear();
    _cvvCtrl.clear();
    _nameCtrl.clear();
    if (mounted) Navigator.pop(context, true);
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
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 48, height: 4,
            decoration: BoxDecoration(
                color: cs.outlineVariant.withAlpha(128),
                borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 24),
        Flexible(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('credit_card.saved_cards'.tr(),
                  style: tt.headlineMedium?.copyWith(fontSize: 20)),
              const SizedBox(height: 16),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_error != null)
                Column(children: [
                  Text(_error!, style: tt.bodySmall?.copyWith(color: cs.error)),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _loading = true;
                        _error = null;
                      });
                      _loadCards();
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text('credit_card.retry'.tr()),
                  ),
                ])
              else if (_cards.isEmpty)
                Text('credit_card.no_saved_cards'.tr(), style: tt.bodySmall)
              else
                ..._cards.map((card) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SavedCardTile(
                    mask: '•••• ${card['card_last4']}',
                    expiry: 'Expires ${card['expiry_month']}/${card['expiry_year']}',
                    isDefault: card['is_default'] == true,
                  ),
                )),
              const SizedBox(height: 32),
              Text('credit_card.add_new_card'.tr(),
                  style: tt.headlineMedium?.copyWith(fontSize: 20)),
              const SizedBox(height: 16),
              AppTextField(
                controller: _numberCtrl,
                label: 'credit_card.card_number'.tr(),
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.credit_card),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: AppTextField(
                    controller: _expiryCtrl,
                    label: 'credit_card.expiry'.tr(),
                    keyboardType: TextInputType.datetime)),
                const SizedBox(width: 16),
                Expanded(child: AppTextField(
                    controller: _cvvCtrl,
                    label: 'credit_card.cvv'.tr(),
                    keyboardType: TextInputType.number,
                    isPassword: true)),
              ]),
              const SizedBox(height: 16),
              AppTextField(
                controller: _nameCtrl,
                label: 'credit_card.name_on_card'.tr(),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveCard,
                  child: Text('credit_card.save_card'.tr()),
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ]),
    );
  }
}
