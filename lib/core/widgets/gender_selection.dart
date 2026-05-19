import 'package:flutter/material.dart';

import 'radio_option.dart';

class GenderSelection extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderChanged;
  final String maleLabel;
  final String femaleLabel;
  final String genderLabel;

  const GenderSelection({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.maleLabel,
    required this.femaleLabel,
    required this.genderLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          genderLabel,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: RadioOption(
            label: maleLabel,
            isSelected: selectedGender == 'male',
            onTap: () => onGenderChanged('male'),
          ),
        ),
        Expanded(
          child: RadioOption(
            label: femaleLabel,
            isSelected: selectedGender == 'female',
            onTap: () => onGenderChanged('female'),
          ),
        ),
      ],
    );
  }
}
