import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/loyalty_tier.dart';
import 'coffee_bean_icon.dart';
import 'loyalty_progress_bar.dart';

class LoyaltyCard extends StatelessWidget {
  final double points;

  const LoyaltyCard({super.key, this.points = 580});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final tier = LoyaltyTier.fromPoints(points);

    // Build localized strings here in build() where context is available.
    final tierName = 'loyalty.${tier.name}'.tr();
    final expiryText = 'loyalty.expires_on'.tr(args: [tier.expiryDate]);
    final targetText = tier.pointsToNext != null
        ? 'loyalty.points_to'.tr(
            args: ['${tier.pointsToNext}', 'loyalty.${tier.nextTier}'.tr()],
          )
        : 'loyalty.max_tier'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardImage(tt, tier, tierName, expiryText),
        const SizedBox(height: 24),
        _buildPointsRow(cs, tt, targetText),
        const SizedBox(height: 14),
        LoyaltyProgressBar(
          progress: tier.progress,
          selectedTierIndex: tier.index,
        ),
      ],
    );
  }

  Widget _buildCardImage(
    TextTheme tt,
    LoyaltyTier tier,
    String tierName,
    String expiryText,
  ) {
    return AspectRatio(
      aspectRatio: 1.62,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: const AssetImage('assets/images/account_card.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              tier.color.withAlpha(140),
              BlendMode.srcATop,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tierName,
                style: tt.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'loyalty.view_benefits'.tr(),
                    style: tt.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(204),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right,
                    size: 14,
                    color: Colors.white.withAlpha(204),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                expiryText,
                style: tt.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(153),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsRow(ColorScheme cs, TextTheme tt, String targetText) {
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
        Row(
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
      ],
    );
  }
}
