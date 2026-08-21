import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/action_button.dart';

class FeaturedItemInfo extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final VoidCallback onCustomize;
  final VoidCallback onAddToCart;

  const FeaturedItemInfo({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.onCustomize,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: AppInsets.h10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.v4,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.subtitleSm(
                    weight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppSpacing.h8,
              InkWell(
                onTap: onCustomize,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: AppInsets.a4,
                  child: Text(
                    'menu_screen.customize'.tr(),
                    style: AppTextStyles.captionSm(
                      weight: FontWeight.w600,
                      color: cs.primary,
                    ).copyWith(letterSpacing: 1.2, height: 1.0),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.v2,
          Expanded(
            child: Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.bodySmall?.copyWith(height: 1.3),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: AppTextStyles.bodyLg(
                  weight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
              ActionButton(
                icon: Icons.add_shopping_cart,
                isPrimary: true,
                onPressed: onAddToCart,
              ),
            ],
          ),
          AppSpacing.v6,
        ],
      ),
    );
  }
}
