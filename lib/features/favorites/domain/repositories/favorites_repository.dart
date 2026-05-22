import '../../../../core/helpers/result.dart';
import '../../../menu/domain/entities/product.dart';

abstract class FavoritesRepository {
  Future<Result<List<Product>>> getFavorites();
  Future<Result<bool>> isFavorite(String productId);
  Future<Result<void>> addFavorite(String productId);
  Future<Result<void>> removeFavorite(String productId);
}
