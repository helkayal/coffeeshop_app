import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:coffeeshop_app/core/cubit/shell_cubit.dart';
import 'package:coffeeshop_app/core/widgets/quick_add_overlay.dart';
import 'package:coffeeshop_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:coffeeshop_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:coffeeshop_app/features/menu/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onQuickAdd;
  final VoidCallback? onFavoriteToggle;
  final bool? isFavorite;
  final VoidCallback? onTap;
  final bool fromFavorites;

  const ProductCard({
    super.key,
    required this.product,
    this.onQuickAdd,
    this.onFavoriteToggle,
    this.isFavorite,
    this.onTap,
    this.fromFavorites = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        border: Border.all(color: cs.outlineVariant.withAlpha(77)),
        borderRadius: BorderRadius.circular(12),
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
                        _FavoriteButton(
                          product: product,
                          isFavorite: isFavorite,
                          onToggle: onFavoriteToggle,
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
                    _ProductActions(
                      product: product,
                      onQuickAdd: onQuickAdd,
                      onTap: onTap,
                      fromFavorites: fromFavorites,
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

class _FavoriteButton extends StatelessWidget {
  final Product product;
  final bool? isFavorite;
  final VoidCallback? onToggle;

  const _FavoriteButton({
    required this.product,
    this.isFavorite,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget buildIcon(bool fav) => SizedBox(
          width: 32,
          height: 32,
          child: IconButton(
            onPressed: onToggle ??
                () => context.read<FavoritesCubit>().toggle(product.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              fav ? Icons.favorite : Icons.favorite_border,
              color: fav ? cs.primary : cs.onSurfaceVariant,
              size: 20,
            ),
          ),
        );

    if (isFavorite != null) {
      return buildIcon(isFavorite!);
    }

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final fav = state is FavoritesLoaded && state.isFavorite(product.id);
        return buildIcon(fav);
      },
    );
  }
}

class _ProductActions extends StatelessWidget {
  final Product product;
  final VoidCallback? onQuickAdd;
  final VoidCallback? onTap;
  final bool fromFavorites;

  const _ProductActions({
    required this.product,
    this.onQuickAdd,
    this.onTap,
    this.fromFavorites = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTap ??
              () => context.read<ShellCubit>().pushSecondary(
                    CustomizationRoute(
                      product: product,
                      fromFavorites: fromFavorites,
                    ),
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
                  price: '${product.basePrice.toStringAsFixed(2)} EGP',
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
