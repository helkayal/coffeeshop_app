import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/order_model.dart';
import 'orders_data_source.dart';

class OrdersDataSourceImpl implements OrdersDataSource {
  final ApiService _api;

  OrdersDataSourceImpl(this._api);

  @override
  Future<List<OrderModel>> getOrders() async {
    final data = await _api.get(ApiConstants.orders);
    final list = data as List<dynamic>;
    return list
        .map((j) => OrderModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    final data = await _api.get('${ApiConstants.orders}/track/$id');
    return OrderModel.fromJson(data as Map<String, dynamic>);
  }

  // // --- Mock data (commented out) ---
  // List<OrderModel> _mockOrders() { ... }
}
