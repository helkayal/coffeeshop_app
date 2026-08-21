import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class CartItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String variant;
  final String price;
  final int quantity;

  const CartItem({
    super.key,
    required this.imagePath,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 96,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: cs.surfaceContainerHighest,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Container(color: cs.surfaceContainerHighest),
          ),
        ),
        AppSpacing.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: AppTextStyles.headlineSm(color: cs.onSurface)
                          .copyWith(height: 1.3),
                    ),
                  ),
                  Text(
                    price,
                    style: AppTextStyles.bodyLg(
                      weight: FontWeight.w500,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
              AppSpacing.v4,
              Text(variant, style: tt.bodySmall),
              AppSpacing.v16,
              Container(
                padding: AppInsets.h12v4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: cs.surfaceContainerLowest,
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove, size: 18, color: cs.onSurfaceVariant),
                    AppSpacing.h16,
                    Text(
                      '$quantity',
                      style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                    ),
                    AppSpacing.h16,
                    Icon(Icons.add, size: 18, color: cs.onSurfaceVariant),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
