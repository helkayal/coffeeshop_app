import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';

class AdditionCard extends StatefulWidget {
  final String name;
  final String price;
  final IconData icon;

  const AdditionCard({
    super.key,
    required this.name,
    required this.price,
    required this.icon,
  });

  @override
  State<AdditionCard> createState() => _AdditionCardState();
}

class _AdditionCardState extends State<AdditionCard> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => setState(() => _selected = !_selected),
      child: Container(
        padding: AppInsets.h20v14,
        decoration: BoxDecoration(
          color: _selected
              ? cs.surfaceContainerHighest
              : cs.surfaceContainerLow.withAlpha(128),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selected ? cs.primary : cs.outlineVariant.withAlpha(102),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, size: 20, color: cs.onSurfaceVariant),
            ),
            AppSpacing.h12,
            Expanded(
              child: Text(
                widget.name,
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              ),
            ),
            Text(
              widget.price,
              style: tt.labelLarge?.copyWith(color: cs.primary),
            ),
          ],
        ),
      ),
    );
  }
}
