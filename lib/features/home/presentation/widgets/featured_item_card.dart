import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_design_constants.dart';
import '../../../../core/widgets/quick_add_overlay.dart';
import '../../../menu/domain/entities/product.dart';
import '../../../menu/presentation/cubit/menu_cubit.dart';
import '../../../menu/presentation/cubit/menu_state.dart';
import 'featured_item_image.dart';
import 'featured_item_info.dart';

class FeaturedItemCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String description;
  final String price;
  final String? menuItemId;

  const FeaturedItemCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.price,
    this.menuItemId,
  });

  Product _getProduct(BuildContext context) {
    Product? product;
    final menuState = context.read<MenuCubit>().state;
    final id = menuItemId;
    if (menuState is MenuLoaded && id != null && id.isNotEmpty) {
      for (final p in menuState.products) {
        if (p.id == menuItemId) {
          product = p;
          break;
        }
      }
    }

    final priceClean = price.replaceAll(RegExp(r'[^\d.]'), '');
    final priceNum = double.tryParse(priceClean) ?? 0.0;
    return product ??
        Product(
          id: id != null && id.isNotEmpty ? id : 'featured_${name.hashCode}',
          name: name,
          description: description,
          imagePath: imagePath,
          basePrice: priceNum,
          category: '',
        );
  }

  void _onAddToCart(BuildContext context) {
    final product = _getProduct(context);

    QuickAddOverlay.show(
      context,
      productName: name,
      productDescription: description,
      productImage: imagePath,
      price: price,
      product: product,
    );
  }

  void _onCustomize(BuildContext context) {
    final product = _getProduct(context);
    context.read<ShellCubit>().pushSecondary(
      CustomizationRoute(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: AppDesignConstants.radius2xl,
        border: Border.all(color: cs.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: FeaturedItemImage(
              imagePath: imagePath,
              color: cs.surfaceContainerHighest,
            ),
          ),
          Expanded(
            flex: 1,
            child: FeaturedItemInfo(
              name: name,
              description: description,
              price: price,
              onCustomize: () => _onCustomize(context),
              onAddToCart: () => _onAddToCart(context),
            ),
          ),
        ],
      ),
    );
  }
}
