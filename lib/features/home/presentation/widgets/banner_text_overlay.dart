import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class BannerTextOverlay extends StatelessWidget {
  final String? subtitle;
  final String? title;

  const BannerTextOverlay({super.key, this.subtitle, this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          subtitle ?? 'home_screen.limited_release'.tr(),
          style: AppTextStyles.labelCaps(color: cs.primary)
              .copyWith(letterSpacing: 2),
        ),
        AppSpacing.v4,
        Text(
          title ?? 'home_screen.autumn_blend'.tr(),
          style: AppTextStyles.headlineSm(
            weight: FontWeight.w700,
            color: AppColors.lightOnPrimary,
          ).copyWith(height: 1.2),
        ),
      ],
    );
  }
}
