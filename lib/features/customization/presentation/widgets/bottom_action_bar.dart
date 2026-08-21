import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

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
      padding: AppInsets.a16,
      decoration: BoxDecoration(
        color: cs.surface.withAlpha(242),
        border: Border(
          top: BorderSide(color: cs.outlineVariant.withAlpha(128)),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'customization.total_estimate'.tr(),
                style: AppTextStyles.labelMicro(color: cs.onSurfaceVariant)
                    .copyWith(letterSpacing: 2, height: 1.0),
              ),
              Text(
                total,
                style: AppTextStyles.headline(color: cs.onSurface),
              ),
            ],
          ),
          const Spacer(),
          IconButton.filled(
            onPressed: onFavorite,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            style: IconButton.styleFrom(
              backgroundColor: cs.surfaceContainerHighest,
              foregroundColor: cs.primary,
            ),
          ),
          AppSpacing.h12,
          FilledButton.icon(
            onPressed: onComplete,
            icon: const Icon(Icons.check_circle, size: 18),
            label: Text(
              'customization.complete_order'.tr(),
              style: tt.labelLarge?.copyWith(color: cs.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
