import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';

class AccountCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const AccountCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppInsets.a16,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant.withAlpha(128)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: cs.primary.withAlpha(26),
              ),
              child: Icon(icon, color: cs.primary, size: 20),
            ),
            AppSpacing.h16,
            Text(label, style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
            const Spacer(),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
