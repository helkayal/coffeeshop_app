import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.name,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.status,
    required super.createdAt,
    required super.items,
    required super.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List;
    return OrderModel(
      id: json['id'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: itemsList
          .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
    );
  }
}
