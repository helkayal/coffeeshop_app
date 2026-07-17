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

class OrderPlaced extends CartState {
  final String orderId;
  final List<CartItem> items;
  final double total;
  const OrderPlaced({
    required this.orderId,
    required this.items,
    required this.total,
  });
}
