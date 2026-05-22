import '../../../../core/helpers/result.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetOrdersUseCase {
  final OrdersRepository _r;
  const GetOrdersUseCase(this._r);
  Future<Result<List<Order>>> call() => _r.getOrders();
}

class GetOrderByIdUseCase {
  final OrdersRepository _r;
  const GetOrderByIdUseCase(this._r);
  Future<Result<Order>> call(String id) => _r.getOrderById(id);
}
