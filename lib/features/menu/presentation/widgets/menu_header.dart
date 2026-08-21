import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          'menu_screen.our_menu'.tr(),
          style: AppTextStyles.display(
            color: AppColors.darkOnBackground,
            weight: FontWeight.w400,
          ),
        ),
        AppSpacing.v16,
        Container(width: 48, height: 1, color: cs.primary.withAlpha(77)),
      ],
    );
  }
}
