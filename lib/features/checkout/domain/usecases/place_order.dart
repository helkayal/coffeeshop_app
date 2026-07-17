import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../data/datasources/checkout_remote_data_source.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

/// Submits the current cart to the API as a new order.
class PlaceOrderUseCase {
  final CartRepository _cartRepo;
  final CheckoutRemoteDataSource _checkoutDs;

  const PlaceOrderUseCase(this._cartRepo, this._checkoutDs);

  /// Returns the server-assigned order ID on success.
  Future<Result<String>> call(Cart cart, {String paymentMethod = 'wallet'}) async {
    if (cart.isEmpty) {
      return const Error(PlaceOrderFailure('Cannot place an empty order'));
    }

    try {
      final items = cart.items.map(_toApiItem).toList();
      final orderId = await _checkoutDs.placeOrder(items: items);
      try {
        await _checkoutDs.checkoutOrder(orderId, paymentMethod: paymentMethod);
      } catch (_) {
        // Non-fatal — order is created even if checkout fails.
      }
      await _cartRepo.clearCart();
      return Success(orderId);
    } on Exception catch (e) {
      return Error(PlaceOrderFailure(
        e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Map<String, dynamic> _toApiItem(CartItem item) {
    final result = <String, dynamic>{
      'menu_item_id': item.productId,
      'quantity': item.quantity,
    };
    if (item.modifierIds.isNotEmpty) {
      result['modifier_ids'] = item.modifierIds;
    }
    return result;
  }
}

class PlaceOrderFailure extends Failure {
  const PlaceOrderFailure(super.message);
}
