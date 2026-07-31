import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/saved_card_tile.dart';

class TopUpSheet extends StatefulWidget {
  final double requiredAmount;
  final VoidCallback onAddPaymentMethod;

  const TopUpSheet({
    super.key,
    required this.requiredAmount,
    required this.onAddPaymentMethod,
  });

  /// Shows the top-up bottom sheet.
  /// Returns the new wallet balance if the top-up succeeded, or null.
  static Future<double?> show(
    BuildContext context, {
    required double requiredAmount,
    required VoidCallback onAddPaymentMethod,
  }) async {
    return showModalBottomSheet<double>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => TopUpSheet(
        requiredAmount: requiredAmount,
        onAddPaymentMethod: onAddPaymentMethod,
      ),
    );
  }

  @override
  State<TopUpSheet> createState() => _TopUpSheetState();
}

class _TopUpSheetState extends State<TopUpSheet> {
  final _api = sl<ApiService>();
  final _cvcCtrl = TextEditingController();
  List<Map<String, dynamic>> _cards = [];
  bool _loadingCards = true;
  bool _toppingUp = false;
  String? _error;
  String? _cvcError;

  @override
  void dispose() {
    _cvcCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    try {
      final data = await _api.get(ApiConstants.paymentMethods);
      if (!mounted) return;
      setState(() {
        _cards = List<Map<String, dynamic>>.from(data as List);
        _loadingCards = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cards = [];
        _loadingCards = false;
      });
    }
  }

  Map<String, dynamic>? get _defaultCard {
    if (_cards.isEmpty) return null;
    return _cards.firstWhere(
      (c) => c['is_default'] == true,
      orElse: () => _cards.first,
    );
  }

  Future<void> _topUp() async {
    final cvc = _cvcCtrl.text.trim();
    if (cvc.length < 3 || cvc.length > 4 || int.tryParse(cvc) == null) {
      setState(() => _cvcError = 'Enter a valid 3 or 4 digit CVC');
      return;
    }

    setState(() {
      _toppingUp = true;
      _error = null;
      _cvcError = null;
    });

    try {
      final result = await _api.post(
        ApiConstants.walletTopup,
        data: {'amount': widget.requiredAmount},
      );
      if (!mounted) return;
      final balance = result['balance'];
      final newBalance = balance is double
          ? balance
          : double.tryParse(balance?.toString() ?? '0') ?? widget.requiredAmount;
      Navigator.pop(context, newBalance);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _toppingUp = false;
        _error = 'Top-up failed. Please try again.';
      });
    }
  }

  void _navigateToPaymentMethods() {
    Navigator.pop(context);
    widget.onAddPaymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
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
          Text(
            'Top Up Wallet',
            style: tt.headlineMedium?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            'You need ${widget.requiredAmount.toStringAsFixed(0)} EGP to complete this order',
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_loadingCards)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )
          else if (_cards.isEmpty)
            _buildNoCards(cs, tt)
          else
            _buildCardConfirmation(cs, tt),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNoCards(ColorScheme cs, TextTheme tt) {
    return Column(
      children: [
        Icon(Icons.credit_card_off, size: 48, color: cs.onSurfaceVariant),
        const SizedBox(height: 16),
        Text(
          'No payment method saved',
          style: tt.bodyMedium?.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          'Add a card to top up your wallet.',
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _navigateToPaymentMethods,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Payment Method'),
          ),
        ),
      ],
    );
  }

  Widget _buildCardConfirmation(ColorScheme cs, TextTheme tt) {
    final card = _defaultCard!;
    final last4 = card['card_last4'] as String? ?? '';
    final expiryMonth = card['expiry_month'];
    final expiryYear = card['expiry_year'];

    return Column(
      children: [
        SavedCardTile(
          mask: '•••• $last4',
          expiry: 'Expires $expiryMonth/$expiryYear',
          isDefault: card['is_default'] == true,
        ),
        const SizedBox(height: 16),
        Text(
          'Top up ${widget.requiredAmount.toStringAsFixed(0)} EGP using this card?',
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 120,
          child: TextField(
            controller: _cvcCtrl,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'CVC',
              counterText: '',
              errorText: _cvcError,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              if (_cvcError != null) {
                setState(() => _cvcError = null);
              }
            },
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            style: tt.bodySmall?.copyWith(color: cs.error),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _toppingUp ? null : _topUp,
            child: _toppingUp
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Confirm Top Up ${widget.requiredAmount.toStringAsFixed(0)} EGP'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _navigateToPaymentMethods,
          child: const Text('Use Another Card'),
        ),
      ],
    );
  }
}
