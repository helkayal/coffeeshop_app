import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/loyalty_tier.dart';
import 'coffee_bean_icon.dart';
import 'loyalty_card_image.dart';
import 'loyalty_progress_bar.dart';

class LoyaltyCard extends StatelessWidget {
  final double points;

  const LoyaltyCard({super.key, this.points = 580});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tier = LoyaltyTier.fromPoints(points);
    final tierName = 'loyalty.${tier.name}'.tr();
    final targetText = tier.pointsToNext != null
        ? 'loyalty.points_to'.tr(
            args: ['${tier.pointsToNext}', 'loyalty.${tier.nextTier}'.tr()],
          )
        : 'loyalty.max_tier'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LoyaltyCardImage(tier: tier, tierName: tierName),
        AppSpacing.v24,
        _buildPointsRow(context, cs, targetText),
        AppSpacing.v14,
        LoyaltyProgressBar(
          progress: tier.progress,
          selectedTierIndex: tier.index,
        ),
      ],
    );
  }

  Widget _buildPointsRow(
    BuildContext context,
    ColorScheme cs,
    String targetText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              points.toStringAsFixed(2),
              style: AppTextStyles.headlineMd(
                weight: FontWeight.w900,
                color: cs.onSurface,
              ),
            ),
            AppSpacing.h6,
            CoffeeBeanIcon(size: 16, color: cs.primary),
          ],
        ),
        GestureDetector(
          onTap: () => context.read<ShellCubit>().pushSecondary(
            const LoyaltyHistoryRoute(),
          ),
          child: Row(
            children: [
              Text(
                targetText,
                style: AppTextStyles.captionSm(
                  weight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
              AppSpacing.h2,
              Icon(Icons.chevron_right, size: 16, color: cs.primary),
            ],
          ),
        ),
      ],
    );
  }
}
