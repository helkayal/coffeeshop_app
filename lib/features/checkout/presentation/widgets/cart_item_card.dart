import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
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
      if (product?.imagePath case final imagePath?) {
        return imagePath;
      }
    }
    return item.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final imageUrl = _resolveImage(context.watch<MenuCubit>().state);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 96,
          height: 120,
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
        AppSpacing.h16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: tt.headlineMedium?.copyWith(
                        fontSize: 24,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              AppSpacing.v4,
              Text(item.variant, style: tt.bodySmall),
              AppSpacing.v4,
              Text(
                'common.price'.tr(
                  namedArgs: {'amount': item.unitPrice.toStringAsFixed(2)},
                ),
                style: tt.bodyLarge?.copyWith(
                  fontSize: 18,
                  color: cs.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSpacing.v12,
              Container(
                padding: AppInsets.h12v4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: cs.surfaceContainerLowest,
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onDecrement,
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.h16,
                    Text(
                      '${item.quantity}',
                      style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                    ),
                    AppSpacing.h16,
                    GestureDetector(
                      onTap: onIncrement,
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
