import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../checkout/presentation/cubit/cart_cubit.dart';
import '../../../customization/presentation/cubit/customization_cubit.dart';
import '../../../customization/presentation/cubit/customization_state.dart';
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
          padding: AppInsets.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'favorites_screen.your_favorites'.tr(),
                style: tt.headlineMedium?.copyWith(fontSize: 30),
              ),
              AppSpacing.v32,
              switch (state) {
                FavoritesLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                FavoritesError(:final message) => Center(
                  child: Text(
                    message,
                    style: tt.bodyMedium?.copyWith(color: cs.error),
                  ),
                ),
                FavoritesLoaded(:final products) when products.isEmpty =>
                  const EmptyState(message: 'favorites_screen.no_favorites'),
                FavoritesLoaded(:final products) => Column(
                  children: [
                    for (final product in products) ...[
                      FavoriteItemCard(
                        product: product,
                        onQuickAdd: () =>
                            _quickAddFromFavorites(context, product),
                      ),
                      AppSpacing.v16,
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

  Future<void> _quickAddFromFavorites(
    BuildContext context,
    Product product,
  ) async {
    final customizationCubit = context.read<CustomizationCubit>();
    final cartCubit = context.read<CartCubit>();
    await customizationCubit.buildQuickAdd(product);
    if (customizationCubit.state case CustomizationQuickAddReady(:final item)) {
      await cartCubit.addItem(item);
    }
  }
}
