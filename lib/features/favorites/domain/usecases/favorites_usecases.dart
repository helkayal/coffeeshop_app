import '../../../../core/helpers/result.dart';
import '../../../menu/domain/entities/product.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository _r;
  const GetFavoritesUseCase(this._r);
  Future<Result<List<Product>>> call() => _r.getFavorites();
}

class ToggleFavoriteUseCase {
  final FavoritesRepository _r;
  const ToggleFavoriteUseCase(this._r);

  /// Adds or removes the product from favorites depending on current state.
  /// Returns the new isFavorite value.
  Future<Result<bool>> call(String productId) async {
    final check = await _r.isFavorite(productId);
    return check.fold(
      (failure) async => Error(failure),
      (isFav) async {
        final op = isFav ? _r.removeFavorite(productId) : _r.addFavorite(productId);
        final result = await op;
        return result.fold(
          (failure) => Error(failure),
          (_) => Success(!isFav),
        );
      },
    );
  }
}
