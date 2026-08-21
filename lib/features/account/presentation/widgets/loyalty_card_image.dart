import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/loyalty_tier.dart';
import '../extensions/loyalty_tier_style.dart';

class LoyaltyCardImage extends StatelessWidget {
  final LoyaltyTier tier;
  final String tierName;
  final String? pointsText;
  final bool showViewBenefits;

  const LoyaltyCardImage({
    super.key,
    required this.tier,
    required this.tierName,
    this.pointsText,
    this.showViewBenefits = true,
  });

  @override
  Widget build(BuildContext context) {
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
              color: AppColors.cardScrim,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: AppInsets.a22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tierName,
                style: AppTextStyles.bodyXl(
                  weight: FontWeight.bold,
                  color: AppColors.lightOnPrimary,
                ),
              ),
              if (pointsText case final text?) ...[
                AppSpacing.v4,
                Text(
                  text,
                  style: AppTextStyles.bodyLarge(
                    weight: FontWeight.w600,
                    color: AppColors.artworkOverlay,
                  ),
                ),
              ],
              if (showViewBenefits) ...[
                AppSpacing.v4,
                GestureDetector(
                  onTap: () => context.read<ShellCubit>().pushSecondary(
                    const ViewBenefitsRoute(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'loyalty.view_benefits'.tr(),
                        style: AppTextStyles.bodyMedium(
                          weight: FontWeight.w600,
                          color: AppColors.artworkOverlay,
                        ),
                      ),
                      AppSpacing.h2,
                      Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: AppColors.artworkOverlay,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
