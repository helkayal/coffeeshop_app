import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/favorites_usecases.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavoritesUseCase _getFavorites;
  final ToggleFavoriteUseCase _toggle;
  final void Function(ConnectionFailure)? onConnectionFailure;

  FavoritesCubit({
    required GetFavoritesUseCase getFavorites,
    required ToggleFavoriteUseCase toggle,
    this.onConnectionFailure,
  })  : _getFavorites = getFavorites,
        _toggle = toggle,
        super(const FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    final result = await _getFavorites();
    result.fold(
      (failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        emit(FavoritesError(failure.message));
      },
      (products) => emit(FavoritesLoaded(
        products: products,
        favoriteIds: products.map((p) => p.id).toSet(),
      )),
    );
  }

  Future<void> toggle(String productId) async {
    final result = await _toggle(productId);
    result.fold(
      (failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        emit(FavoritesError(failure.message));
      },
      (_) => loadFavorites(),
    );
  }
}
