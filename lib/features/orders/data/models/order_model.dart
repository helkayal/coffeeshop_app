import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.name,
    required super.quantity,
    required super.price,
    super.menuItemId,
    super.selections,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final priceRaw = json['unit_price_at_purchase'];
    final price = priceRaw is double
        ? priceRaw
        : double.tryParse(priceRaw?.toString() ?? '0') ?? 0.0;

    final selectionsRaw = json['selections'];
    final selections = selectionsRaw is List
        ? selectionsRaw.map((s) => Map<String, dynamic>.from(s as Map)).toList()
        : <Map<String, dynamic>>[];

    return OrderItemModel(
      name: (json['menu_item_name'] as String?) ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      price: price,
      menuItemId: (json['menu_item_id'] as String?) ?? '',
      selections: selections,
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
    final totalRaw = json['total_amount'];
    final total = totalRaw is double
        ? totalRaw
        : double.tryParse(totalRaw?.toString() ?? '0') ?? 0.0;

    final itemsList = (json['items'] as List<dynamic>?) ?? [];

    return OrderModel(
      id: json['id'] as String,
      status: (json['order_status'] as String?) ?? 'unknown',
      createdAt: DateTime.parse(json['created_at'] as String),
      items: itemsList
          .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
          .toList(),
      total: total,
    );
  }
}
