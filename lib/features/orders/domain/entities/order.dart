import 'order_item.dart';

class Order {
  final String id;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;
  final double total;

  const Order({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.items,
    required this.total,
  });
}
