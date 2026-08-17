import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_design_constants.dart';
import '../theme/app_insets.dart';
import '../theme/app_spacing.dart';

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
          padding: AppInsets.h16,
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
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
              isExpanded: true,
              dropdownColor: colorScheme.surface,
              icon: Icon(Icons.keyboard_arrow_down, color: colorScheme.outline),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    useLocalization ? item.tr() : item,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (errorText case final error?)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.s12, top: AppSpacing.s4),
            child: Text(
              error,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
      ],
    );
  }
}
