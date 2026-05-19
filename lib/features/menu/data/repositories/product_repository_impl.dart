import '../../../../core/errors/exceptions.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../mock_data.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(ProductRemoteDataSource remoteDataSource)
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<Product>>> getProducts({String? categoryId}) async {
    try {
      final models = await _remoteDataSource.getProducts(categoryId: categoryId);
      return Success(models);
    } on ServerException catch (e) {
      return _fallback(categoryId, e);
    } catch (e) {
      return _fallback(categoryId);
    }
  }

  Result<List<Product>> _fallback(String? categoryId, [ServerException? e]) {
    final products = categoryId != null
        ? MockData.products.where((p) => p.category == categoryId).toList()
        : MockData.products;
    return Success(products);
  }
}
