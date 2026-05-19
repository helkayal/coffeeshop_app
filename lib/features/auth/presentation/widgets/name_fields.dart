import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/app_text_field.dart';

class NameFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  const NameFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: firstNameController,
            hintText: 'auth.first_name'.tr(),
            prefixIcon: Icon(Icons.person_outline, color: colorScheme.outline),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppTextField(
            controller: lastNameController,
            hintText: 'auth.last_name'.tr(),
          ),
        ),
      ],
    );
  }
}
