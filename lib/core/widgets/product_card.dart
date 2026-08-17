import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/app_insets.dart';
import '../theme/app_spacing.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onViewMore;
  final VoidCallback onQuickAdd;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onViewMore,
    required this.onQuickAdd,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border.all(color: colors.outlineVariant.withAlpha(77)),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    ColoredBox(color: colors.surfaceContainerHighest),
                errorWidget: (_, _, _) => Image.asset(
                  'assets/images/no_item_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: AppInsets.a16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: text.headlineMedium?.copyWith(
                              fontSize: 18,
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onFavoriteToggle,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? colors.primary
                                : colors.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall,
                    ),
                    AppSpacing.v12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: onViewMore,
                          child: Text('menu_screen.view_more'.tr()),
                        ),
                        IconButton.filledTonal(
                          onPressed: onQuickAdd,
                          icon: const Icon(Icons.add_shopping_cart, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
