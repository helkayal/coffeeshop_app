import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/orders/data/datasources/orders_data_source.dart';
import 'package:coffeeshop_app/features/orders/data/models/order_model.dart';
import 'package:coffeeshop_app/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:coffeeshop_app/features/orders/domain/entities/order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrdersRepositoryImpl.getOrders', () {
    test('returns orders mapped from the data source models', () async {
      final repository = OrdersRepositoryImpl(
        _FakeOrdersDataSource(
          orders: [
            OrderModel.fromJson({
              'id': 'order-1',
              'order_status': 'completed',
              'created_at': '2026-08-15T10:00:00Z',
              'total_amount': '25.00',
              'items': [
                {
                  'menu_item_name': 'Latte',
                  'menu_item_id': 'latte-1',
                  'quantity': 2,
                  'unit_price_at_purchase': '4.50',
                  'selections': [
                    {'modifier_group': 'Milk', 'option_name': 'Oat'},
                  ],
                },
              ],
            }),
          ],
        ),
      );

      final result = await repository.getOrders();

      final orders = (result as Success<List<Order>>).data;
      expect(orders, hasLength(1));
      final order = orders.first;
      expect(order.id, 'order-1');
      expect(order.status, 'completed');
      expect(order.createdAt, DateTime.parse('2026-08-15T10:00:00Z'));
      expect(order.total, 25.0);
      final item = order.items.single;
      expect(item.name, 'Latte');
      expect(item.quantity, 2);
      expect(item.price, 4.5);
      expect(item.menuItemId, 'latte-1');
      expect(item.selections, [
        {'modifier_group': 'Milk', 'option_name': 'Oat'},
      ]);
      expect(item.total, 9.0);
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = OrdersRepositoryImpl(
        _FakeOrdersDataSource(error: const ServerException('orders_down')),
      );

      final result = await repository.getOrders();

      final failure = (result as Error<List<Order>>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'orders_down');
    });

    test('falls back to the default key when the ServerException has no message',
        () async {
      final repository = OrdersRepositoryImpl(
        _FakeOrdersDataSource(error: const ServerException()),
      );

      final result = await repository.getOrders();

      expect(
        (result as Error<List<Order>>).failure.message,
        'errors.orders_load_failed',
      );
    });

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = OrdersRepositoryImpl(
        _FakeOrdersDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.getOrders();

      final failure = (result as Error<List<Order>>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = OrdersRepositoryImpl(
        _FakeOrdersDataSource(error: Exception('boom')),
      );

      final result = await repository.getOrders();

      final failure = (result as Error<List<Order>>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });

  group('OrdersRepositoryImpl.getOrderById', () {
    test('returns the order for the requested id', () async {
      final dataSource = _FakeOrdersDataSource(
        order: OrderModel.fromJson({
          'id': 'order-1',
          'order_status': 'pending',
          'created_at': '2026-08-15T10:00:00Z',
          'total_amount': '12.00',
          'items': [],
        }),
      );
      final repository = OrdersRepositoryImpl(dataSource);

      final result = await repository.getOrderById('order-1');

      expect(dataSource.requestedId, 'order-1');
      final order = (result as Success<Order>).data;
      expect(order.id, 'order-1');
      expect(order.status, 'pending');
      expect(order.total, 12.0);
    });

    test('maps a ServerException to a ServerFailure with its message', () async {
      final repository = OrdersRepositoryImpl(
        _FakeOrdersDataSource(error: const ServerException('missing')),
      );

      final result = await repository.getOrderById('order-1');

      final failure = (result as Error<Order>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'missing');
    });

    test('falls back to the default key when the ServerException has no message',
        () async {
      final repository = OrdersRepositoryImpl(
        _FakeOrdersDataSource(error: const ServerException()),
      );

      final result = await repository.getOrderById('order-1');

      expect(
        (result as Error<Order>).failure.message,
        'errors.order_not_found',
      );
    });

    test('maps a ConnectionException to a ConnectionFailure', () async {
      final repository = OrdersRepositoryImpl(
        _FakeOrdersDataSource(error: const ConnectionException('no network')),
      );

      final result = await repository.getOrderById('order-1');

      final failure = (result as Error<Order>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'no network');
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = OrdersRepositoryImpl(
        _FakeOrdersDataSource(error: Exception('boom')),
      );

      final result = await repository.getOrderById('order-1');

      final failure = (result as Error<Order>).failure;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'errors.unexpected_error');
    });
  });
}

class _FakeOrdersDataSource implements OrdersDataSource {
  _FakeOrdersDataSource({this.orders = const [], this.order, this.error});

  final List<OrderModel> orders;
  final OrderModel? order;
  final Exception? error;
  String? requestedId;

  @override
  Future<List<OrderModel>> getOrders() async {
    final e = error;
    if (e != null) throw e;
    return orders;
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    requestedId = id;
    final e = error;
    if (e != null) throw e;
    return order!;
  }
}
