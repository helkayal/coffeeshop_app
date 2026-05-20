import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';

class CreditCardSheet extends StatelessWidget {
  const CreditCardSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CreditCardSheet(),
    );
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
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 48, height: 4,
          decoration: BoxDecoration(
            color: cs.outlineVariant.withAlpha(128),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 24),
        Flexible(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Saved Cards', style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
              const SizedBox(height: 16),
              _savedCard(cs, tt, '•••• 4242', 'Expires 12/28'),
              const SizedBox(height: 8),
              _savedCard(cs, tt, '•••• 8371', 'Expires 06/27'),
              const SizedBox(height: 32),
              Text('Add New Card', style: tt.headlineMedium?.copyWith(fontSize: 20, color: cs.onSurface)),
              const SizedBox(height: 16),
              const AppTextField(label: 'Card Number', keyboardType: TextInputType.number, prefixIcon: Icon(Icons.credit_card)),
              const SizedBox(height: 16),
              Row(children: [
                const Expanded(child: AppTextField(label: 'Expiry', keyboardType: TextInputType.datetime)),
                const SizedBox(width: 16),
                const Expanded(child: AppTextField(label: 'CVV', keyboardType: TextInputType.number, isPassword: true)),
              ]),
              const SizedBox(height: 16),
              const AppTextField(label: 'Name on Card', prefixIcon: Icon(Icons.person_outline)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Save Card')),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _savedCard(ColorScheme cs, TextTheme tt, String mask, String expiry) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(77)),
      ),
      child: Row(children: [
        Icon(Icons.credit_card, color: cs.primary, size: 24),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(mask, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
          Text(expiry, style: tt.bodySmall),
        ]),
        const Spacer(),
        Icon(Icons.check_circle, color: cs.primary, size: 20),
      ]),
    );
  }
}
