import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  final String total;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onComplete;

  const BottomActionBar({
    super.key,
    required this.total,
    required this.isFavorite,
    required this.onFavorite,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface.withAlpha(242),
        border: Border(top: BorderSide(color: cs.outlineVariant.withAlpha(128))),
      ),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('customization.total_estimate'.tr(),
              style: tt.labelLarge?.copyWith(
                  fontSize: 10, color: cs.onSurfaceVariant, letterSpacing: 2)),
          Text(total,
              style: tt.headlineMedium?.copyWith(fontSize: 30, color: cs.onSurface)),
        ]),
        const Spacer(),
        IconButton.filled(
          onPressed: onFavorite,
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          style: IconButton.styleFrom(
              backgroundColor: cs.surfaceContainerHighest,
              foregroundColor: cs.primary),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: onComplete,
          icon: const Icon(Icons.check_circle, size: 18),
          label: Text('customization.complete_order'.tr(),
              style: tt.labelLarge?.copyWith(color: cs.onPrimary)),
        ),
      ]),
    );
  }
}
