import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../mock_data.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService _api;

  ProductRemoteDataSourceImpl(this._api);

  @override
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    try {
      final params = <String, dynamic>{};
      if (categoryId != null) params['category_id'] = categoryId;
      final response = await _api.get(ApiConstants.products, queryParameters: params);
      final list = response.data as List;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (_) {
      throw const ServerException('Failed to load products');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _api.get('${ApiConstants.products}/$id');
      return ProductModel.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      // Fallback to mock for offline / mock mode
      final product = MockData.products.cast<ProductModel?>().firstWhere(
            (p) => p?.id == id,
            orElse: () => null,
          );
      if (product != null) return product;
      throw const ServerException('Product not found');
    }
  }
}
