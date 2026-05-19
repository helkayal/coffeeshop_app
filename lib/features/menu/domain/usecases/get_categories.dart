import '../../../../core/helpers/result.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository _repository;

  GetCategories(this._repository);

  Future<Result<List<Category>>> call() => _repository.getCategories();
}
