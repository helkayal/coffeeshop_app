import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: AppInsets.a16,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: tt.labelLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  value,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onEdit,
              icon: Icon(Icons.edit, size: 18, color: cs.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}
