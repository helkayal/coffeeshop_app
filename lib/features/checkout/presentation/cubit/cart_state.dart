import '../../domain/entities/cart.dart';

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
  final Cart cart; // keep showing current cart while action runs
  const CartActionInProgress(this.cart);
}

class OrderPlaced extends CartState {
  final String orderId;
  const OrderPlaced(this.orderId);
}
