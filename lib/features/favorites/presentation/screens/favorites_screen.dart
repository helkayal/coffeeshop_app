import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../checkout/domain/entities/cart_item.dart';
import '../../../checkout/presentation/cubit/cart_cubit.dart';
import '../../../menu/domain/entities/option_value.dart';
import '../../../menu/domain/entities/product.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../widgets/favorite_item_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('favorites_screen.your_favorites'.tr(),
                  style: tt.headlineMedium?.copyWith(fontSize: 30)),
              const SizedBox(height: 32),
              switch (state) {
                FavoritesLoading() => const Center(child: CircularProgressIndicator()),
                FavoritesError(:final message) => Center(
                    child: Text(message,
                        style: tt.bodyMedium?.copyWith(color: cs.error))),
                FavoritesLoaded(:final products) when products.isEmpty =>
                  const EmptyState(message: 'favorites_screen.no_favorites'),
                FavoritesLoaded(:final products) => Column(
                    children: [
                      for (final product in products) ...[
                        FavoriteItemCard(
                          product: product,
                          onQuickAdd: () => _quickAddFromFavorites(context, product),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                _ => const SizedBox.shrink(),
              },
            ],
          ),
        );
      },
    );
  }

  /// Adds to cart using saved favorite customization.
  /// If an identical item (same product + same modifiers) already exists in
  /// the cart, CartCubit automatically increments its quantity instead of adding a duplicate.
  void _quickAddFromFavorites(BuildContext context, Product product) {
    final storage = sl<LocalStorageService>();
    final saved = storage.getFavoriteSelections(product.id);
    final cartCubit = context.read<CartCubit>();

    final variantParts = <String>[];
    final modifierIds = <String>[];
    double upcharge = 0;

    for (final g in product.optionGroups) {
      if (g.values.isEmpty) continue;

      final name = g.name.toLowerCase();
      final isMulti = name.contains('extra') || name.contains('add-on');

      if (isMulti) {
        final toggledMap = saved?['toggled'];
        final savedIds = (toggledMap is Map ? toggledMap[g.id] : null);
        if (savedIds is List) {
          for (final v in g.values) {
            if (savedIds.contains(v.id)) {
              variantParts.add(v.name);
              modifierIds.add(v.id);
              upcharge += v.priceModifier;
            }
          }
        }
      } else {
        final pickedMap = saved?['picked'];
        final savedId = (pickedMap is Map ? pickedMap[g.id] : null) as String?;
        OptionValue? opt;
        if (savedId != null) {
          opt = g.values.cast<OptionValue?>().firstWhere(
            (v) => v?.id == savedId,
            orElse: () => null,
          );
        }
        opt ??= (g.values.isNotEmpty ? g.values.first : null);
        if (opt != null) {
          variantParts.add(opt.name);
          modifierIds.add(opt.id);
          upcharge += opt.priceModifier;
        }
      }
    }

    final item = CartItem(
      id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
      productId: product.id,
      name: product.name,
      imagePath: product.imagePath ?? '',
      variant: variantParts.join(' • '),
      unitPrice: product.basePrice + upcharge,
      quantity: 1,
      modifierIds: modifierIds,
    );

    cartCubit.addItem(item);
  }
}
