import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? categoryId});
  Future<ProductModel> getProductById(String id);
  /// Fetches GET /menu once and returns both categories and products.
  Future<({List<CategoryModel> categories, List<ProductModel> products})> getMenu();
}
