import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/quick_add_overlay.dart';
import '../../../../features/customization/presentation/screens/customization_screen.dart';
import '../../domain/entities/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

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
            Container(
              width: 120,
              color: cs.surfaceContainerHighest,
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: cs.surfaceContainerHighest),
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
                        Icon(
                          Icons.favorite_border,
                          color: cs.onSurfaceVariant,
                          size: 20,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomizationScreen())),
                          child: Text(
                            'menu_screen.view_more'.tr(),
                            style: tt.labelLarge?.copyWith(color: cs.primary),
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
                            onPressed: () => QuickAddOverlay.show(
                              context,
                              productName: product.name,
                              productDescription: product.description,
                              productImage: product.imagePath,
                              price: '\$${product.basePrice.toStringAsFixed(2)}',
                            ),
                            icon: Icon(Icons.add_shopping_cart, color: cs.primary),
                          ),
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
