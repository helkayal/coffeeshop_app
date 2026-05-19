import '../../../../core/helpers/result.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<Result<List<Category>>> getCategories();
}
