import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import '../theme/app_design_constants.dart';

class AppDropdown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? errorText;
  final bool useLocalization;

  const AppDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.useLocalization = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppDesignConstants.radiusMedium,
            border: Border.all(
              color: hasError ? colorScheme.error : colorScheme.outlineVariant,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
              ),
              isExpanded: true,
              dropdownColor: colorScheme.surface,
              icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.outline),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    useLocalization ? item.tr() : item,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText!,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
      ],
    );
  }
}
