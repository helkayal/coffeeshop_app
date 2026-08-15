import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../menu/domain/entities/product.dart';
import '../cubit/favorites_cubit.dart';

class FavoriteItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onQuickAdd;

  const FavoriteItemCard({
    super.key,
    required this.product,
    required this.onQuickAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ProductCard(
      imageUrl: product.imagePath ?? '',
      name: product.name,
      description: product.description,
      isFavorite: true,
      onFavoriteToggle: () => context.read<FavoritesCubit>().toggle(product.id),
      onViewMore: () => context.read<ShellCubit>().pushSecondary(
        CustomizationRoute(product: product, fromFavorites: true),
      ),
      onQuickAdd: onQuickAdd,
    );
  }
}
