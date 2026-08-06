import 'package:flutter/material.dart';

import '../../features/menu/domain/entities/option_value.dart';

class QuickAddOptionCard extends StatelessWidget {
  final OptionValue option;
  final bool isSelected;
  final VoidCallback onTap;

  const QuickAddOptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? cs.primary.withAlpha(26)
              : cs.surfaceContainerHigh.withAlpha(128),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant.withAlpha(77),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.add_circle_outline,
              size: 20,
              color: isSelected ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.name,
                style: tt.bodyMedium?.copyWith(
                  color: isSelected ? cs.primary : cs.onSurface,
                ),
              ),
            ),
            if (option.priceModifier > 0)
              Text(
                '+\$${option.priceModifier.toStringAsFixed(2)}',
                style: tt.labelLarge?.copyWith(color: cs.primary),
              ),
          ],
        ),
      ),
    );
  }
}
