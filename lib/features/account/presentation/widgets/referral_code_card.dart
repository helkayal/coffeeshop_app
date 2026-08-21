import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ReferralCodeCard extends StatelessWidget {
  final String code;
  final VoidCallback onShare;
  final VoidCallback onCopy;

  const ReferralCodeCard({
    super.key,
    required this.code,
    required this.onShare,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Container(
        width: double.infinity,
        padding: AppInsets.a20,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outlineVariant.withAlpha(128)),
        ),
        child: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              color: cs.primary,
              tooltip: 'referral.share'.tr(),
              onPressed: onShare,
            ),
            AppSpacing.v12,
            Container(
              padding: AppInsets.h16v10,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.primary.withAlpha(77)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        code,
                        style: AppTextStyles.subtitle(
                          weight: FontWeight.w800,
                          color: cs.primary,
                        ).copyWith(height: 1.5, letterSpacing: 2),
                      ),
                    ),
                  ),
                  AppSpacing.h8,
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    color: cs.primary,
                    onPressed: onCopy,
                    constraints: const BoxConstraints(),
                    padding: AppInsets.zero,
                  ),
                ],
              ),
            ),
            AppSpacing.v12,
            Text(
              'referral.share_earn'.tr(),
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
