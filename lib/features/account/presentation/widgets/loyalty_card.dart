import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
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
    final tt = Theme.of(context).textTheme;
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
        const SizedBox(height: 24),
        _buildPointsRow(context, cs, tt, targetText),
        const SizedBox(height: 14),
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
    TextTheme tt,
    String targetText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              points.toStringAsFixed(2),
              style: tt.headlineMedium?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(width: 5),
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
                style: tt.bodyMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 2),
              Icon(Icons.chevron_right, size: 16, color: cs.primary),
            ],
          ),
        ),
      ],
    );
  }
}
