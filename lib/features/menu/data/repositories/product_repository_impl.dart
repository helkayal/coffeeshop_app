import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/category.dart';
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
      return Success(List<Product>.from(models));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.products_load_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }

  @override
  Future<Result<Product>> getProductById(String id) async {
    try {
      final model = await _remoteDataSource.getProductById(id);
      return Success(model);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.product_not_found'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }

  @override
  Future<Result<MenuData>> getMenu() async {
    try {
      final raw = await _remoteDataSource.getMenu();
      return Success((
        categories: List<Category>.from(raw.categories),
        products: List<Product>.from(raw.products),
      ));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.menu_load_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }
}
