import 'package:flutter/material.dart';

import '../theme/app_breakpoints.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final bool isPrimary;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    this.isPrimary = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isTablet = context.isTablet;
    final size = isTablet ? 44.0 : 28.0;
    final iconSize = isTablet ? 22.0 : 16.0;

    if (isPrimary) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: cs.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: cs.primary.withAlpha(51),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: iconSize,
          onPressed: onPressed,
          icon: Icon(icon, color: cs.onPrimary),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: cs.outlineVariant.withAlpha(153)),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: iconSize,
        onPressed: onPressed,
        icon: Icon(icon, color: cs.onSurfaceVariant),
      ),
    );
  }
}
