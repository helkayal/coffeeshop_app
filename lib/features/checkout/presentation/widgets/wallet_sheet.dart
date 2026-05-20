import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';

class WalletSheet extends StatelessWidget {
  const WalletSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const WalletSheet(),
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
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 48, height: 4,
          decoration: BoxDecoration(
            color: cs.outlineVariant.withAlpha(128),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 24),
        Text('Phone for Wallet', style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
        const SizedBox(height: 24),
        const AppTextField(
          label: 'Phone Number',
          keyboardType: TextInputType.phone,
          prefixIcon: Icon(Icons.phone_android),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Continue')),
        ),
        const SizedBox(height: 16),
      ]),
    );
  }
}
