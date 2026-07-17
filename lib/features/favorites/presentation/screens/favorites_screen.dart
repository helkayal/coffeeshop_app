import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';


import '../../../../core/widgets/empty_state.dart';
import '../../../checkout/domain/entities/cart_item.dart';
import '../../../checkout/presentation/cubit/cart_cubit.dart';
import '../../../menu/presentation/widgets/product_list_item.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

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
                        ProductListItem(
                          product: product,
                          onQuickAdd: () {
                            final cartCubit = context.read<CartCubit>();
                            final variantParts = <String>[];
                            double upcharge = 0;
                            for (final g in product.optionGroups) {
                              if (g.values.isNotEmpty) {
                                final opt = g.values.first;
                                variantParts.add(opt.name);
                                upcharge += opt.priceModifier;
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
                            );
                            cartCubit.addItem(item);
                          },
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
}
