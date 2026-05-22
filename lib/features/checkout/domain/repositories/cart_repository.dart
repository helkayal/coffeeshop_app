import '../../../../core/helpers/result.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Result<Cart>> getCart();
  Future<Result<Cart>> addItem(CartItem item);
  Future<Result<Cart>> updateQuantity(String itemId, int quantity);
  Future<Result<Cart>> removeItem(String itemId);
  Future<Result<void>> clearCart();
}
