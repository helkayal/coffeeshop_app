import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/category_model.dart';
import 'category_remote_data_source.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService _api;

  CategoryRemoteDataSourceImpl(this._api);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final data = await _api.get(ApiConstants.menu);
    final list = data as List<dynamic>;

    return list.map((json) {
      final cat = json as Map<String, dynamic>;
      return CategoryModel.fromJson({
        'id': cat['id'],
        'name': cat['name'],
      });
    }).toList();
  }
}
