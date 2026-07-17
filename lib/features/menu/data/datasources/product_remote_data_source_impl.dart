import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService _api;

  ProductRemoteDataSourceImpl(this._api);

  /// Single API call that parses the /menu tree into both categories and products.
  /// All other methods delegate to this to avoid duplicate HTTP requests.
  @override
  Future<({List<CategoryModel> categories, List<ProductModel> products})>
      getMenu() async {
    final rawCategories = await _api.get(ApiConstants.menu) as List<dynamic>;

    final categories = <CategoryModel>[];
    final products = <ProductModel>[];

    for (final cat in rawCategories) {
      final catJson = cat as Map<String, dynamic>;
      final catId = catJson['id'] as String;
      final catName = catJson['name'] as String? ?? '';

      categories.add(CategoryModel.fromJson({
        'id': catId,
        'name': catName,
      }));

      final items = catJson['items'] as List<dynamic>? ?? [];
      for (final item in items) {
        final itemJson = Map<String, dynamic>.from(item as Map);
        // Inject category context so ProductModel can resolve the category id.
        itemJson['_category_id'] = catId;
        itemJson['_category_name'] = catName;
        products.add(ProductModel.fromJson(itemJson));
      }
    }

    return (categories: categories, products: products);
  }

  @override
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    final menu = await getMenu();
    if (categoryId == null) return menu.products;
    return menu.products.where((p) => p.category == categoryId).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final menu = await getMenu();
    final product = menu.products.cast<ProductModel?>().firstWhere(
      (p) => p?.id == id,
      orElse: () => null,
    );
    if (product != null) return product;
    throw const ServerException('Product not found');
  }
}
