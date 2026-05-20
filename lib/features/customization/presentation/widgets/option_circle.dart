import 'package:flutter/material.dart';

import 'option_group.dart';

class OptionCircle extends StatelessWidget {
  final OptionData data;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCircle({
    super.key,
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? cs.surfaceContainer : cs.surfaceContainerLow,
            border: Border.all(
              color: isSelected ? cs.primary : cs.outlineVariant.withAlpha(153),
              width: 2,
            ),
          ),
          child: Icon(data.icon, size: 32,
              color: isSelected ? cs.primary : cs.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        Text(data.name, style: tt.labelLarge?.copyWith(
            color: isSelected ? cs.primary : cs.onSurface,
            fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(data.priceLabel, style: tt.bodySmall?.copyWith(
            color: isSelected ? cs.primary : cs.onSurfaceVariant)),
      ]),
    );
  }
}
