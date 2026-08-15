import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../features/checkout/presentation/widgets/payment_method_selector.dart';

class TopUpSheet extends StatelessWidget {
  const TopUpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SingleChildScrollView(
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
                'wallet.top_up'.tr(),
                style: tt.headlineMedium?.copyWith(
                  fontSize: 20,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              const PaymentMethodSelector(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('wallet.add'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
