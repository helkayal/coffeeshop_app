import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

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
      return Error(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return const Error(ServerFailure('Unexpected Error'));
    }
  }
}
