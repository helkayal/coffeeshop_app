import 'package:flutter/material.dart';

import '../../data/models/wallet_package_model.dart';

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
        padding: const EdgeInsets.all(16),
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
            const SizedBox(width: 14),
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '+${package.loyaltyPoints} pts',
                          style: tt.labelSmall?.copyWith(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '2x Loyalty Bonus',
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
              '${package.amount.toStringAsFixed(0)} EGP',
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
