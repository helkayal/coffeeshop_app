import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';


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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Text('favorites_screen.no_favorites'.tr(),
                          style: tt.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant)),
                    ),
                  ),
                FavoritesLoaded(:final products) => Column(
                    children: [
                      for (final product in products) ...[
                        FavoriteItemCard(
                          product: product,
                          onRemove: () =>
                              context.read<FavoritesCubit>().toggle(product.id),
                        ),
                        const SizedBox(height: 24),
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
