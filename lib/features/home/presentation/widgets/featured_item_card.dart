import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_design_constants.dart';
import '../../../../core/widgets/quick_add_overlay.dart';
import '../../../menu/domain/entities/product.dart';
import '../../../menu/presentation/cubit/menu_cubit.dart';
import '../../../menu/presentation/cubit/menu_state.dart';
import 'action_button.dart';

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

  void _onAddToCart(BuildContext context) {
    Product? product;
    final menuState = context.read<MenuCubit>().state;
    if (menuState is MenuLoaded && menuItemId != null && menuItemId!.isNotEmpty) {
      for (final p in menuState.products) {
        if (p.id == menuItemId) {
          product = p;
          break;
        }
      }
    }

    final priceClean = price.replaceAll(RegExp(r'[^\d.]'), '');
    final priceNum = double.tryParse(priceClean) ?? 0.0;
    product ??= Product(
      id: (menuItemId != null && menuItemId!.isNotEmpty)
          ? menuItemId!
          : 'featured_${name.hashCode}',
      name: name,
      description: description,
      imagePath: imagePath,
      basePrice: priceNum,
      category: '',
    );

    QuickAddOverlay.show(
      context,
      productName: name,
      productDescription: description,
      productImage: imagePath,
      price: price,
      product: product,
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _FeatureImage(imagePath: imagePath, color: cs.surfaceContainerHighest),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: tt.displaySmall?.copyWith(fontSize: 20, fontWeight: FontWeight.w700, color: cs.onSurface)),
              const SizedBox(height: 4),
              Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: tt.bodySmall?.copyWith(height: 1.625)),
              const Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(price, style: tt.bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w700, color: cs.primary)),
                ActionButton(
                  icon: Icons.add_shopping_cart,
                  isPrimary: true,
                  onPressed: () => _onAddToCart(context),
                ),
              ]),
              const SizedBox(height: 5),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _FeatureImage extends StatelessWidget {
  final String imagePath;
  final Color color;
  const _FeatureImage({required this.imagePath, required this.color});

  @override
  Widget build(BuildContext context) {
    final isNetwork = imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(AppDesignConstants.borderRadius2xl)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Center(
          child: isNetwork
              ? Image.network(
                  imagePath,
                  height: MediaQuery.of(context).size.height * .25,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _fallbackAsset(),
                )
              : (imagePath.isNotEmpty)
                  ? Image.asset(
                      imagePath,
                      height: MediaQuery.of(context).size.height * .25,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _fallbackAsset(),
                    )
                  : _fallbackAsset(),
        ),
      ),
    );
  }

  Widget _fallbackAsset() {
    return Image.asset(
      'assets/images/cardamom_cose_latte.png',
      height: 180,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(color: color),
    );
  }
}
