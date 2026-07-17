import '../../../../core/helpers/result.dart';
import '../entities/product.dart';
import '../usecases/get_menu.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({String? categoryId});
  Future<Result<Product>> getProductById(String id);
  Future<Result<MenuData>> getMenu();
}
