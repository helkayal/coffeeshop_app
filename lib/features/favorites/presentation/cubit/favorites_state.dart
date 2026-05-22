import '../../../menu/domain/entities/product.dart';

sealed class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<Product> products;
  final Set<String> favoriteIds;

  const FavoritesLoaded({required this.products, required this.favoriteIds});

  bool isFavorite(String productId) => favoriteIds.contains(productId);
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
}
