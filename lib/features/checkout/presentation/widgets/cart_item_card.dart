import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../menu/domain/entities/product.dart';
import '../../../menu/presentation/cubit/menu_cubit.dart';
import '../../../menu/presentation/cubit/menu_state.dart';
import '../../domain/entities/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  String _resolveImage(MenuState? menuState) {
    if (item.imagePath.isNotEmpty) return item.imagePath;
    if (menuState is MenuLoaded && item.productId.isNotEmpty) {
      Product? product;
      for (final p in menuState.products) {
        if (p.id == item.productId) {
          product = p;
          break;
        }
      }
      if (product != null && product.imagePath != null) {
        return product.imagePath!;
      }
    }
    return item.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final imageUrl = _resolveImage(context.watch<MenuCubit>().state);

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 96, height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: cs.surfaceContainerHighest,
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(color: cs.surfaceContainerHighest),
            errorWidget: (_, _, _) => Image.asset(
              'assets/images/no_item_image.png',
              fit: BoxFit.cover,
            ),
          ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Text(item.name,
                  style: tt.headlineMedium?.copyWith(fontSize: 24, color: cs.onSurface)),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onRemove,
              icon: Icon(Icons.close, size: 18, color: cs.onSurfaceVariant),
            ),
          ]),
          const SizedBox(height: 4),
          Text(item.variant, style: tt.bodySmall),
          const SizedBox(height: 4),
          Text('${item.unitPrice.toStringAsFixed(2)} EGP',
              style: tt.bodyLarge?.copyWith(fontSize: 18, color: cs.primary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: cs.surfaceContainerLowest,
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: onDecrement,
                child: Icon(Icons.remove, size: 18, color: cs.onSurfaceVariant),
              ),
              const SizedBox(width: 16),
              Text('${item.quantity}',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: onIncrement,
                child: Icon(Icons.add, size: 18, color: cs.onSurfaceVariant),
              ),
            ]),
          ),
        ]),
      ),
    ]);
  }
}
