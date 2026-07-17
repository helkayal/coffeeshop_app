import '../../../../core/helpers/result.dart';
import '../entities/category.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Fetches the full menu in a single API call and returns both
/// categories and products. Use this instead of calling GetProducts
/// and GetCategories separately to avoid duplicate HTTP requests.
typedef MenuData = ({List<Category> categories, List<Product> products});

class GetMenu {
  final ProductRepository _repository;

  GetMenu(this._repository);

  Future<Result<MenuData>> call() => _repository.getMenu();
}
