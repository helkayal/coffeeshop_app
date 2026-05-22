import 'package:flutter/material.dart';

import '../../../../core/widgets/quick_add_overlay.dart';
import '../../../menu/domain/entities/product.dart';

class FavoriteItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onRemove;

  const FavoriteItemCard({
    super.key,
    required this.product,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withAlpha(128)),
      ),
      child: Row(children: [
        Container(
          width: 96, height: 96,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: cs.surfaceContainerHighest),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(product.imagePath, fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: cs.surfaceContainerHighest)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(product.name,
                    style: tt.displaySmall?.copyWith(
                        fontSize: 20, color: cs.onSurface)),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onRemove,
                icon: Icon(Icons.favorite, color: cs.primary, size: 22),
              ),
            ]),
            const SizedBox(height: 4),
            Text(product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tt.bodySmall),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('\$${product.basePrice.toStringAsFixed(2)}',
                  style: tt.displaySmall
                      ?.copyWith(fontSize: 18, color: cs.primary)),
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    shape: BoxShape.circle),
                child: IconButton(
                  padding: EdgeInsets.zero, iconSize: 16,
                  onPressed: () => QuickAddOverlay.show(
                    context,
                    productName: product.name,
                    productDescription: product.description,
                    productImage: product.imagePath,
                    price: '\$${product.basePrice.toStringAsFixed(2)}',
                  ),
                  icon: Icon(Icons.shopping_cart, color: cs.onSurfaceVariant),
                ),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }
}
