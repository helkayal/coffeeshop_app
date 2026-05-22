import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../mock_data.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Product>>> getProducts({String? categoryId}) async {
    try {
      final models = await _remoteDataSource.getProducts(categoryId: categoryId);
      return Success(models);
    } on ServerException catch (e) {
      return _fallbackList(categoryId, e);
    } catch (_) {
      return _fallbackList(categoryId);
    }
  }

  @override
  Future<Result<Product>> getProductById(String id) async {
    try {
      final model = await _remoteDataSource.getProductById(id);
      return Success(model);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Product not found'));
    } catch (_) {
      return const Error(ServerFailure('Unexpected Error'));
    }
  }

  Result<List<Product>> _fallbackList(String? categoryId, [ServerException? _]) {
    final products = categoryId != null
        ? MockData.products.where((p) => p.category == categoryId).toList()
        : MockData.products;
    return Success(products);
  }
}
