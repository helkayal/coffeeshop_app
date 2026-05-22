import '../../domain/entities/order.dart';

sealed class OrdersState {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final List<Order> orders;
  const OrdersLoaded(this.orders);

  Order? get latestOrder => orders.isNotEmpty ? orders.first : null;
}

class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);
}
