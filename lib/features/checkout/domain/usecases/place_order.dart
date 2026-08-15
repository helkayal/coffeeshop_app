import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../entities/cart.dart';
import '../entities/checkout_item.dart';
import '../repositories/cart_repository.dart';
import '../repositories/checkout_repository.dart';

sealed class PlaceOrderOutcome {
  final String orderId;

  const PlaceOrderOutcome(this.orderId);
}

final class OrderCompleted extends PlaceOrderOutcome {
  const OrderCompleted(super.orderId);
}

final class OrderPaymentPending extends PlaceOrderOutcome {
  final Failure failure;

  const OrderPaymentPending(super.orderId, this.failure);
}

final class OrderCleanupWarning extends PlaceOrderOutcome {
  final Failure failure;

  const OrderCleanupWarning(super.orderId, this.failure);
}

class PlaceOrderUseCase {
  final CartRepository _cartRepository;
  final CheckoutRepository _checkoutRepository;

  const PlaceOrderUseCase(this._cartRepository, this._checkoutRepository);

  Future<Result<PlaceOrderOutcome>> call(
    Cart cart, {
    String paymentMethod = 'wallet',
  }) async {
    if (cart.isEmpty) {
      return const Error(PlaceOrderFailure('empty_cart'));
    }

    final items = cart.items
        .map(
          (item) => CheckoutItem(
            productId: item.productId,
            quantity: item.quantity,
            modifierIds: item.modifierIds,
          ),
        )
        .toList(growable: false);
    final createResult = await _checkoutRepository.createOrder(items);
    if (createResult case Error<String>(:final failure)) {
      return Error(failure);
    }
    final orderId = (createResult as Success<String>).data;
    final paymentResult = await _checkoutRepository.payForOrder(
      orderId,
      paymentMethod,
    );
    if (paymentResult case Error<void>(:final failure)) {
      return Success(OrderPaymentPending(orderId, failure));
    }

    for (final item in cart.items) {
      final cleanup = await _cartRepository.removeItem(item.id);
      if (cleanup case Error<Cart>(:final failure)) {
        return Success(OrderCleanupWarning(orderId, failure));
      }
    }
    return Success(OrderCompleted(orderId));
  }
}

class PlaceOrderFailure extends Failure {
  const PlaceOrderFailure(super.message);
}
