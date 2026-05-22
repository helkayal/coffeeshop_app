import '../../../../core/helpers/result.dart';
import '../entities/order.dart';

abstract class OrdersRepository {
  Future<Result<List<Order>>> getOrders();
  Future<Result<Order>> getOrderById(String id);
}
