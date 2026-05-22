import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({String? categoryId});
  Future<ProductModel> getProductById(String id);
}
