import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/orders/domain/entities/order.dart';
import 'package:coffeeshop_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:coffeeshop_app/features/orders/domain/usecases/orders_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetOrdersUseCase', () {
    test('returns the list of orders from the repository', () async {
      final useCase = GetOrdersUseCase(
        _FakeOrdersRepository(ordersResult: Success([_order])),
      );

      final result = await useCase();

      final orders = (result as Success<List<Order>>).data;
      expect(orders.single.id, 'order-1');
      expect(orders.single.status, 'completed');
    });

    test('propagates a repository failure', () async {
      final useCase = GetOrdersUseCase(
        _FakeOrdersRepository(
          ordersResult: const Error(ServerFailure('errors.orders_load_failed')),
        ),
      );

      final result = await useCase();

      expect(
        (result as Error<List<Order>>).failure.message,
        'errors.orders_load_failed',
      );
    });
  });

  group('GetOrderByIdUseCase', () {
    test('returns the order for the requested id', () async {
      final repository = _FakeOrdersRepository(orderResult: Success(_order));
      final useCase = GetOrderByIdUseCase(repository);

      final result = await useCase('order-1');

      expect(repository.requestedId, 'order-1');
      expect((result as Success<Order>).data.id, 'order-1');
    });

    test('propagates a repository failure', () async {
      final useCase = GetOrderByIdUseCase(
        _FakeOrdersRepository(
          orderResult: const Error(ServerFailure('errors.order_not_found')),
        ),
      );

      final result = await useCase('order-1');

      expect(
        (result as Error<Order>).failure.message,
        'errors.order_not_found',
      );
    });
  });
}

final _order = Order(
  id: 'order-1',
  status: 'completed',
  createdAt: DateTime(2026, 8, 15, 10),
  items: const [],
  total: 25,
);

class _FakeOrdersRepository implements OrdersRepository {
  _FakeOrdersRepository({
    this.ordersResult = const Success(<Order>[]),
    this.orderResult,
  });

  final Result<List<Order>> ordersResult;
  final Result<Order>? orderResult;
  String? requestedId;

  @override
  Future<Result<List<Order>>> getOrders() async => ordersResult;

  @override
  Future<Result<Order>> getOrderById(String id) async {
    requestedId = id;
    return orderResult ?? Success(_order);
  }
}
