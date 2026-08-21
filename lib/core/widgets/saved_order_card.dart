import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/checkout/domain/entities/cart_item.dart';
import '../../features/checkout/presentation/cubit/cart_cubit.dart';
import '../../features/menu/domain/entities/product.dart';
import '../../features/orders/domain/entities/order_item.dart';
import '../theme/app_insets.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class SavedOrderCard extends StatelessWidget {
  final OrderItem item;
  final Product product;
  final String productName;
  final String productImage;
  final void Function(CartItem cartItem) onAddToCart;

  const SavedOrderCard({
    super.key,
    required this.item,
    required this.product,
    required this.productName,
    required this.productImage,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: AppInsets.a12,
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
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
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.headlineXs(color: cs.primary),
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
                  'common.quantity_price'.tr(
                    namedArgs: {
                      'quantity': item.quantity.toString(),
                      'price': 'common.price'.tr(
                        namedArgs: {'amount': item.price.toStringAsFixed(2)},
                      ),
                    },
                  ),
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          AppSpacing.h8,
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
                final cartCubit = context.read<CartCubit>();
                onAddToCart(
                  cartCubit.reorderOrderItem(
                    product,
                    item,
                    productName: productName,
                  ),
                );
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
