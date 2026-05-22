import '../../../../core/helpers/result.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository _repository;

  const GetProductByIdUseCase(this._repository);

  Future<Result<Product>> call(String id) => _repository.getProductById(id);
}
