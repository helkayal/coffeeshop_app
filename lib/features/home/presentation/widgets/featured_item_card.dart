import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_design_constants.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/action_button.dart';
import '../../../../core/widgets/quick_add_overlay.dart';
import '../../../menu/domain/entities/product.dart';
import '../../../menu/presentation/cubit/menu_cubit.dart';
import '../../../menu/presentation/cubit/menu_state.dart';

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
    final tt = Theme.of(context).textTheme;

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
            child: _FeatureImage(
              imagePath: imagePath,
              color: cs.surfaceContainerHighest,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
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
                          style: tt.displaySmall?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppSpacing.h8,
                      InkWell(
                        onTap: () => _onCustomize(context),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: AppInsets.a4,
                          child: Text(
                            'menu_screen.customize'.tr(),
                            style: tt.labelLarge?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
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
                        style: tt.bodyLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                      ActionButton(
                        icon: Icons.add_shopping_cart,
                        isPrimary: true,
                        onPressed: () => _onAddToCart(context),
                      ),
                    ],
                  ),
                  AppSpacing.v6,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureImage extends StatelessWidget {
  final String imagePath;
  final Color color;
  const _FeatureImage({required this.imagePath, required this.color});

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(AppDesignConstants.borderRadius2xl),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: color,
        child: isNetwork
            ? Image.network(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallbackAsset(),
              )
            : (imagePath.isNotEmpty)
            ? Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _fallbackAsset(),
              )
            : _fallbackAsset(),
      ),
    );
  }

  Widget _fallbackAsset() {
    return Image.asset(
      'assets/images/cardamom_cose_latte.png',
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(color: color),
    );
  }
}
