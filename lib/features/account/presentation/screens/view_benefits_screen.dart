import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/loyalty_tier.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/benefits_all_tiers.dart';
import '../widgets/benefits_earn_points.dart';
import '../widgets/loyalty_card_image.dart';

class ViewBenefitsScreen extends StatelessWidget {
  const ViewBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final points = state is ProfileLoaded ? state.loyaltyPoints : 0.0;
        final tier = LoyaltyTier.fromPoints(points);
        final tierName = 'loyalty.${tier.name}'.tr();

        return Scaffold(
          backgroundColor: cs.surface,
          body: SingleChildScrollView(
            padding: AppInsets.screenTop24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoyaltyCardImage(
                  tier: tier,
                  tierName: tierName,
                  pointsText:
                      '${points.toStringAsFixed(0)} ${'benefits.points'.tr()}',
                  showViewBenefits: false,
                ),
                AppSpacing.v32,
                _sectionTitle(tt, 'benefits.rewards'.tr()),
                AppSpacing.v16,
                BenefitsAllTiers(currentIndex: tier.index),
                AppSpacing.v32,
                _sectionTitle(tt, 'benefits.how_to_earn'.tr()),
                AppSpacing.v16,
                const BenefitsEarnPoints(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(TextTheme tt, String text) {
    return Text(
      text,
      style: tt.headlineMedium?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
