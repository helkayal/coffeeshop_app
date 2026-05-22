import '../../../../core/helpers/result.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository _r;
  const GetCartUseCase(this._r);
  Future<Result<Cart>> call() => _r.getCart();
}

class AddToCartUseCase {
  final CartRepository _r;
  const AddToCartUseCase(this._r);
  Future<Result<Cart>> call(CartItem item) => _r.addItem(item);
}

class UpdateCartItemUseCase {
  final CartRepository _r;
  const UpdateCartItemUseCase(this._r);
  Future<Result<Cart>> call(String itemId, int quantity) =>
      _r.updateQuantity(itemId, quantity);
}

class RemoveCartItemUseCase {
  final CartRepository _r;
  const RemoveCartItemUseCase(this._r);
  Future<Result<Cart>> call(String itemId) => _r.removeItem(itemId);
}

class ClearCartUseCase {
  final CartRepository _r;
  const ClearCartUseCase(this._r);
  Future<Result<void>> call() => _r.clearCart();
}
