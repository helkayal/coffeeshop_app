import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../models/category_model.dart';
import 'category_remote_data_source.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService _api;

  CategoryRemoteDataSourceImpl(this._api);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _api.get('/categories');
      final list = response.data as List;
      return list.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw const ServerException('Failed to load categories');
    }
  }
}
