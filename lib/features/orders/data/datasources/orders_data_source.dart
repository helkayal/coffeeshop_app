import '../models/order_model.dart';

abstract class OrdersDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(String id);
}
