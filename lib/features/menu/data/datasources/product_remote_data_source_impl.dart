import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService _api;

  ProductRemoteDataSourceImpl(this._api);

  @override
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) queryParams['category_id'] = categoryId;

      final response = await _api.get('/products', queryParameters: queryParams);
      final list = response.data as List;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw const ServerException('Failed to load products');
    }
  }
}
