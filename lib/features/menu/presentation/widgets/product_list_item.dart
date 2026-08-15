import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/quick_add_overlay.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../../domain/entities/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => ProductCard(
        imageUrl: product.imagePath ?? '',
        name: product.name,
        description: product.description,
        isFavorite: state is FavoritesLoaded && state.isFavorite(product.id),
        onFavoriteToggle: () =>
            context.read<FavoritesCubit>().toggle(product.id),
        onViewMore: () => context.read<ShellCubit>().pushSecondary(
          CustomizationRoute(product: product),
        ),
        onQuickAdd: () => QuickAddOverlay.show(
          context,
          productName: product.name,
          productDescription: product.description,
          productImage: product.imagePath ?? '',
          price: product.basePrice.toStringAsFixed(2),
          product: product,
        ),
      ),
    );
  }
}
