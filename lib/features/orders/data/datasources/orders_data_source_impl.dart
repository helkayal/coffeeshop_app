import '../../../../config/app_config.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../models/order_model.dart';
import 'orders_data_source.dart';

class OrdersDataSourceImpl implements OrdersDataSource {
  final ApiService _api;

  OrdersDataSourceImpl(this._api);

  @override
  Future<List<OrderModel>> getOrders() async {
    if (AppConfig.useMockData) return _mockOrders();

    try {
      final response = await _api.get(ApiConstants.orders);
      final list = response.data as List;
      return list.map((j) => OrderModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (_) {
      throw const ServerException('Failed to load orders');
    }
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    if (AppConfig.useMockData) {
      return _mockOrders().firstWhere(
        (o) => o.id == id,
        orElse: () => throw const ServerException('Order not found'),
      );
    }
    try {
      final response = await _api.get('${ApiConstants.orders}/$id');
      return OrderModel.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      throw const ServerException('Failed to load order');
    }
  }

  List<OrderModel> _mockOrders() {
    return [
      OrderModel(
        id: 'ORD-001',
        status: 'Delivered',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        total: 18.50,
        items: const [
          OrderItemModel(name: 'Ethiopian Yirgacheffe', quantity: 2, price: 6.50),
          OrderItemModel(name: 'Almond Croissant', quantity: 1, price: 5.50),
        ],
      ),
      OrderModel(
        id: 'ORD-002',
        status: 'Processing',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        total: 13.00,
        items: const [
          OrderItemModel(name: 'Honey Lavender Latte', quantity: 2, price: 6.50),
        ],
      ),
      OrderModel(
        id: 'ORD-003',
        status: 'Picked Up',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        total: 24.50,
        items: const [
          OrderItemModel(name: 'Artisan Vanilla Latte', quantity: 1, price: 7.25),
          OrderItemModel(name: 'Butter Croissant', quantity: 2, price: 4.50),
          OrderItemModel(name: 'Desert Midnight', quantity: 1, price: 5.75),
        ],
      ),
    ];
  }
}
