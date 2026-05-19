import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import '../theme/app_design_constants.dart';

class AppDropdown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const AppDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDesignConstants.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
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
                item.tr(),
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
