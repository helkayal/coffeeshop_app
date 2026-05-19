import '../../../../core/helpers/result.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository _repository;

  GetProducts(this._repository);

  Future<Result<List<Product>>> call({String? categoryId}) =>
      _repository.getProducts(categoryId: categoryId);
}
