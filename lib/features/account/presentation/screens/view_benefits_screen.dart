import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/loyalty_tier.dart';
import '../widgets/benefits_all_tiers.dart';
import '../widgets/benefits_earn_points.dart';
import '../widgets/loyalty_card_image.dart';

class ViewBenefitsScreen extends StatelessWidget {
  final double points;

  const ViewBenefitsScreen({super.key, this.points = 580});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final tier = LoyaltyTier.fromPoints(points);
    final tierName = 'loyalty.${tier.name}'.tr();

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoyaltyCardImage(tier: tier, tierName: tierName, pointsText: '${points.toStringAsFixed(0)} ${'benefits.points'.tr()}', showViewBenefits: false),
          const SizedBox(height: 32),
          _sectionTitle(tt, 'benefits.rewards'.tr()),
          const SizedBox(height: 16),
          BenefitsAllTiers(currentIndex: tier.index),
          const SizedBox(height: 32),
          _sectionTitle(tt, 'benefits.how_to_earn'.tr()),
          const SizedBox(height: 16),
          const BenefitsEarnPoints(),
        ],
      ),
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
