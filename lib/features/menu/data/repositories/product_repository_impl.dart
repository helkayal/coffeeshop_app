import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_menu.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Product>>> getProducts({String? categoryId}) async {
    try {
      final models = await _remoteDataSource.getProducts(
        categoryId: categoryId,
      );
      return Success(models);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to load products'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<Product>> getProductById(String id) async {
    try {
      final model = await _remoteDataSource.getProductById(id);
      return Success(model);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Product not found'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<MenuData>> getMenu() async {
    try {
      final raw = await _remoteDataSource.getMenu();
      return Success((categories: raw.categories, products: raw.products));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to load menu'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }
}
