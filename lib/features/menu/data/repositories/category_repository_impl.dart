import '../../../../core/helpers/result.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';
import '../mock_data.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl(CategoryRemoteDataSource remoteDataSource)
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final models = await _remoteDataSource.getCategories();
      return Success(models);
    } catch (_) {
      return Success(MockData.categories);
    }
  }
}
