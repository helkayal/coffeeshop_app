import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/favorites_usecases.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase _getFavorites;
  final ToggleFavoriteUseCase _toggle;

  FavoritesCubit({
    required GetFavoritesUseCase getFavorites,
    required ToggleFavoriteUseCase toggle,
  })  : _getFavorites = getFavorites,
        _toggle = toggle,
        super(const FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    final result = await _getFavorites();
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (products) => emit(FavoritesLoaded(
        products: products,
        favoriteIds: products.map((p) => p.id).toSet(),
      )),
    );
  }

  Future<void> toggle(String productId) async {
    final result = await _toggle(productId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => loadFavorites(), // Reload to get updated list from source of truth.
    );
  }
}
