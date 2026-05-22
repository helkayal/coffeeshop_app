import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Submits the current cart to the API as a new order.
class PlaceOrderUseCase {
  final CartRepository _r;
  const PlaceOrderUseCase(this._r);

  /// Returns the server-assigned order ID on success.
  Future<Result<String>> call(Cart cart) async {
    if (cart.isEmpty) {
      return const Error(
        _CartError('Cannot place an empty order'),
      );
    }
    // The repository delegates the API call; cart is cleared after success.
    return _placeAndClear(cart);
  }

  Future<Result<String>> _placeAndClear(Cart cart) async {
    // TODO: delegate to an OrderRemoteDataSource when backend is ready.
    // For now, mock order placement success.
    await Future.delayed(const Duration(milliseconds: 800));
    await _r.clearCart();
    return const Success('ORD-MOCK-001');
  }
}

class _CartError extends Failure {
  const _CartError(super.message);
}
