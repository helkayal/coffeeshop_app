import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl(CategoryRemoteDataSource remoteDataSource)
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final models = await _remoteDataSource.getCategories();
      return Success(models);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to load categories'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }
}
