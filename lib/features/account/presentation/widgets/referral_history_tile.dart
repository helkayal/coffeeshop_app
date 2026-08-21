import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/referral_history_entry.dart';

class ReferralHistoryTile extends StatelessWidget {
  final ReferralHistoryEntry item;

  const ReferralHistoryTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final date = DateFormat.yMd(
      context.locale.toString(),
    ).format(item.createdAt);

    return Container(
      padding: AppInsets.a16,
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: cs.primary, size: 24),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.referredEmail,
                  style: AppTextStyles.bodyMedium(
                    weight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  date,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            'loyalty.points_value'.tr(
              namedArgs: {'points': '+${item.pointsEarned}'},
            ),
            style: AppTextStyles.bodyLarge(
              weight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}
