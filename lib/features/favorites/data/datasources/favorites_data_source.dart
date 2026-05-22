import '../../../../config/app_config.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../menu/data/mock_data.dart';
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

  // In-memory set for mock mode — resets on app restart.
  final Set<String> _mockFavoriteIds = {};

  FavoritesDataSourceImpl(this._api);

  @override
  Future<List<Product>> getFavorites() async {
    if (AppConfig.useMockData) {
      return MockData.products
          .where((p) => _mockFavoriteIds.contains(p.id))
          .toList();
    }
    try {
      final response = await _api.get(ApiConstants.favorites);
      final list = response.data as List;
      return list
          .map((j) => ProductModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const ServerException('Failed to load favorites');
    }
  }

  @override
  Future<bool> isFavorite(String productId) async {
    if (AppConfig.useMockData) return _mockFavoriteIds.contains(productId);
    try {
      final response = await _api.get('${ApiConstants.favorites}/$productId');
      return (response.data as Map<String, dynamic>)['is_favorite'] as bool;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> addFavorite(String productId) async {
    if (AppConfig.useMockData) {
      _mockFavoriteIds.add(productId);
      return;
    }
    try {
      await _api.post(ApiConstants.favorites, data: {'product_id': productId});
    } catch (_) {
      throw const ServerException('Failed to add favorite');
    }
  }

  @override
  Future<void> removeFavorite(String productId) async {
    if (AppConfig.useMockData) {
      _mockFavoriteIds.remove(productId);
      return;
    }
    try {
      await _api.delete('${ApiConstants.favorites}/$productId');
    } catch (_) {
      throw const ServerException('Failed to remove favorite');
    }
  }
}
