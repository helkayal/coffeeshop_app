import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_text_field.dart';

class AddCardForm extends StatelessWidget {
  const AddCardForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'credit_card.add_new_card'.tr(),
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'credit_card.card_number'.tr(),
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.credit_card),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'credit_card.expiry'.tr(),
                keyboardType: TextInputType.datetime,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'credit_card.cvv'.tr(),
                keyboardType: TextInputType.number,
                isPassword: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'credit_card.name_on_card'.tr(),
          prefixIcon: const Icon(Icons.person_outline),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text('credit_card.save_card'.tr()),
          ),
        ),
      ],
    );
  }
}
