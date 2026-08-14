import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../features/checkout/domain/entities/cart_item.dart';
import '../../features/menu/domain/entities/product.dart';
import '../../features/orders/domain/entities/order_item.dart';

class SavedOrderCard extends StatelessWidget {
  final OrderItem item;
  final Product? product;
  final String productName;
  final String productImage;
  final void Function(CartItem cartItem) onAddToCart;

  const SavedOrderCard({
    super.key,
    required this.item,
    this.product,
    required this.productName,
    required this.productImage,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withAlpha(51)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 64,
              height: 64,
              child: productImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: productImage,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) =>
                          Container(color: cs.surfaceContainerHighest),
                    )
                  : Container(color: cs.surfaceContainerHighest),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: tt.headlineMedium?.copyWith(
                    fontSize: 16,
                    color: cs.primary,
                  ),
                ),
                if (item.selections.isNotEmpty)
                  Text(
                    item.selections
                        .map((s) => s['modifier_name'] ?? '')
                        .join(', '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodySmall,
                  ),
                Text(
                  'x${item.quantity}  ${item.price.toStringAsFixed(2)} EGP',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 20,
              onPressed: () {
                final variantParts = item.selections
                    .map((s) => s['modifier_name'] as String? ?? '')
                    .where((s) => s.isNotEmpty)
                    .toList();
                final ids = item.selections
                    .map((s) => s['modifier_id'] as String? ?? '')
                    .where((s) => s.isNotEmpty)
                    .toList();
                final variant = variantParts.isNotEmpty
                    ? variantParts.join(' • ')
                    : productName;
                final cartItem = CartItem(
                  id: '${product?.id ?? ''}_${DateTime.now().millisecondsSinceEpoch}',
                  productId: product?.id ?? '',
                  name: productName,
                  imagePath: productImage,
                  variant: variant,
                  unitPrice: item.price,
                  quantity: item.quantity,
                  modifierIds: ids,
                );
                onAddToCart(cartItem);
                Navigator.pop(context);
              },
              icon: Icon(Icons.replay, color: cs.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
