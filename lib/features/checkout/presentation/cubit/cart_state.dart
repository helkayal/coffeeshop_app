import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';

sealed class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final Cart cart;
  const CartLoaded(this.cart);
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
}

class CartActionInProgress extends CartState {
  final Cart cart;
  const CartActionInProgress(this.cart);
}

sealed class OrderResultState extends CartState {
  final String orderId;
  final List<CartItem> items;
  final double total;
  const OrderResultState({
    required this.orderId,
    required this.items,
    required this.total,
  });
}

final class OrderPlaced extends OrderResultState {
  const OrderPlaced({
    required super.orderId,
    required super.items,
    required super.total,
  });
}

final class OrderPaymentPendingState extends OrderResultState {
  final String failureCode;

  const OrderPaymentPendingState({
    required super.orderId,
    required super.items,
    required super.total,
    required this.failureCode,
  });
}

final class OrderCleanupWarningState extends OrderResultState {
  final String failureCode;

  const OrderCleanupWarningState({
    required super.orderId,
    required super.items,
    required super.total,
    required this.failureCode,
  });
}
