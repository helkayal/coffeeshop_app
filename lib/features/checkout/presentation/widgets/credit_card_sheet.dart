import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/add_card_form.dart';
import '../../../../core/widgets/saved_card_tile.dart';

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
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 48, height: 4, decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(128),
          borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 24),
        Flexible(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('credit_card.saved_cards'.tr(), style: tt.headlineMedium?.copyWith(fontSize: 20)),
              const SizedBox(height: 16),
              const SavedCardTile(mask: '•••• 4242', expiry: 'Expires 12/28'),
              const SizedBox(height: 8),
              const SavedCardTile(mask: '•••• 8371', expiry: 'Expires 06/27'),
              const SizedBox(height: 32),
              const AddCardForm(),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ]),
    );
  }
}
