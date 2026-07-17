import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/quick_add_overlay.dart';
import '../../../../core/cubit/shell_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../../domain/entities/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onQuickAdd;

  const ProductListItem({super.key, required this.product, this.onQuickAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border.all(color: cs.outlineVariant.withAlpha(77)),
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.imagePath ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        Container(color: cs.surfaceContainerHighest),
                    errorWidget: (_, _, _) => Image.asset(
                      'assets/images/no_item_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: tt.headlineMedium?.copyWith(
                              fontSize: 18,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                        BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, favState) {
                            final isFav =
                                favState is FavoritesLoaded &&
                                favState.isFavorite(product.id);
                            return IconButton(
                              onPressed: () => context
                                  .read<FavoritesCubit>()
                                  .toggle(product.id),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? cs.primary : cs.onSurfaceVariant,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tt.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    _ProductActions(product: product, onQuickAdd: onQuickAdd),
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

class _ProductActions extends StatelessWidget {
  final Product product;
  final VoidCallback? onQuickAdd;
  const _ProductActions({required this.product, this.onQuickAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => context.read<ShellCubit>().pushSecondary(
            CustomizationRoute(product: product),
          ),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
            child: Text(
              'menu_screen.view_more'.tr(),
              style: tt.labelLarge?.copyWith(color: cs.primary),
            ),
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: cs.primary.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 16,
            onPressed: () {
              if (onQuickAdd != null) {
                onQuickAdd!();
              } else {
                QuickAddOverlay.show(
                  context,
                  productName: product.name,
                  productDescription: product.description,
                  productImage: product.imagePath ?? '',
                  price: '\$${product.basePrice.toStringAsFixed(2)}',
                  product: product,
                );
              }
            },
            icon: Icon(Icons.add_shopping_cart, color: cs.primary),
          ),
        ),
      ],
    );
  }
}
