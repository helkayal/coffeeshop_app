import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_insets.dart';
import '../theme/app_spacing.dart';

class ConnectionErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ConnectionErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: AppInsets.h32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_item_image.png',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Icon(
                Icons.wifi_off_rounded,
                size: 80,
                color: cs.outlineVariant,
              ),
            ),
            AppSpacing.v24,
            Text(
              message,
              textAlign: TextAlign.center,
              style: tt.bodyLarge?.copyWith(color: cs.onSurface, height: 1.5),
            ),
            AppSpacing.v32,
            SizedBox(
              width: 200,
              child: FilledButton.icon(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: AppInsets.v14,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh, size: 20),
                label: Text(
                  'splash_screen.try_again'.tr(),
                  style: tt.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
