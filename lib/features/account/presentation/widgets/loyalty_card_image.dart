import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../domain/entities/loyalty_tier.dart';

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
    final tt = Theme.of(context).textTheme;

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
              Text(tierName, style: tt.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
              if (pointsText != null) ...[
                const SizedBox(height: 4),
                Text(pointsText!, style: tt.bodyMedium?.copyWith(color: Colors.white.withAlpha(204), fontWeight: FontWeight.w600, fontSize: 16)),
              ],
              if (showViewBenefits) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => context.read<ShellCubit>().pushSecondary(const ViewBenefitsRoute()),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('loyalty.view_benefits'.tr(), style: tt.bodyMedium?.copyWith(color: Colors.white.withAlpha(204), fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(width: 2),
                    Icon(Icons.chevron_right, size: 14, color: Colors.white.withAlpha(204)),
                  ]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
