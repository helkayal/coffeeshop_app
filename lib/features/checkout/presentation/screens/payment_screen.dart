import 'package:flutter/material.dart';

import '../../../../core/widgets/app_app_bar.dart';
import '../widgets/payment_option.dart';
import '../widgets/payment_order_summary.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _usePoints = true;
  String _paymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const AppAppBar(title: 'Coffee Shop', leading: BackButton()),
      body: Stack(children: [
        SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
        child: Column(children: [
          const SizedBox(height: 16),
          Text('Complete Order', style: tt.headlineMedium?.copyWith(fontSize: 36, color: cs.onSurface)),
          const SizedBox(height: 8),
          Text('Secure checkout', style: tt.bodySmall),
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
              Text('Payment Method', style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
              const SizedBox(height: 16),
              PaymentOption(
                icon: Icons.star, label: 'Use Points First',
                isSelected: _usePoints, isCheckbox: true,
                onTap: () => setState(() => _usePoints = !_usePoints),
              ),
              const SizedBox(height: 12),
              PaymentOption(icon: Icons.payments, label: 'Credit Card', isSelected: _paymentMethod == 'card', onTap: () => setState(() => _paymentMethod = 'card')),
              const SizedBox(height: 12),
              PaymentOption(icon: Icons.account_balance_wallet, label: 'Wallets', isSelected: _paymentMethod == 'wallet', onTap: () => setState(() => _paymentMethod = 'wallet')),
              const SizedBox(height: 12),
              PaymentOption(icon: Icons.contactless, label: 'Apple Pay', isSelected: _paymentMethod == 'applepay', onTap: () => setState(() => _paymentMethod = 'applepay')),
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
              onPressed: () {},
              icon: const Icon(Icons.check_circle, size: 20),
              label: const Text('CONFIRM ORDER'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ),
        ),
      ),
    ]),
    );
  }
}
