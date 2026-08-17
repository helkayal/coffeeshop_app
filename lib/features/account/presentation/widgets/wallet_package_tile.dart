import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/wallet_package.dart';

class WalletPackageTile extends StatelessWidget {
  final WalletPackage package;
  final bool isSelected;
  final VoidCallback onTap;

  const WalletPackageTile({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppInsets.a16,
        decoration: BoxDecoration(
          color: isSelected
              ? cs.primary.withAlpha(26)
              : cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant.withAlpha(77),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? cs.primary : cs.outlineVariant,
            ),
            AppSpacing.h14,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  AppSpacing.v4,
                  Row(
                    children: [
                      Container(
                        padding: AppInsets.h8v2,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'wallet.loyalty_points_value'.tr(
                            namedArgs: {
                              'points': package.loyaltyPoints.toString(),
                            },
                          ),
                          style: tt.labelSmall?.copyWith(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      AppSpacing.h8,
                      Text(
                        'wallet.loyalty_bonus'.tr(),
                        style: tt.bodySmall?.copyWith(
                          color: cs.secondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'common.price'.tr(
                namedArgs: {'amount': package.amount.toStringAsFixed(0)},
              ),
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
