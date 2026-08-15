import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../menu/data/models/product_model.dart';
import '../../../menu/domain/entities/product.dart';

abstract class FavoritesDataSource {
  Future<List<Product>> getFavorites();
  Future<bool> isFavorite(String productId);
  Future<void> addFavorite(String productId);
  Future<void> removeFavorite(String productId);
}

class FavoritesDataSourceImpl implements FavoritesDataSource {
  final ApiService _api;

  // final Set<String> _mockFavoriteIds = {'1', '2', '3', '4'};
  final Set<String> _cachedFavoriteIds = {};

  FavoritesDataSourceImpl(this._api);

  @override
  Future<List<Product>> getFavorites() async {
    final data = await _api.get(ApiConstants.favorites);
    final list = data as List<dynamic>;
    final products = list
        .map((j) => ProductModel.fromJson(j as Map<String, dynamic>))
        .toList();

    _cachedFavoriteIds.clear();
    for (final p in products) {
      _cachedFavoriteIds.add(p.id);
    }

    return products;
  }

  @override
  Future<bool> isFavorite(String productId) async {
    return _cachedFavoriteIds.contains(productId);
  }

  @override
  Future<void> addFavorite(String productId) async {
    await _api.post(ApiConstants.favorites, data: {'menu_item_id': productId});
    _cachedFavoriteIds.add(productId);
  }

  @override
  Future<void> removeFavorite(String productId) async {
    await _api.delete('${ApiConstants.favorites}/$productId');
    _cachedFavoriteIds.remove(productId);
  }
}
