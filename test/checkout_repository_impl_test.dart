import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:coffeeshop_app/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:coffeeshop_app/features/checkout/domain/entities/checkout_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CheckoutRepositoryImpl.createOrder', () {
    test('maps items to the payload and returns the order id', () async {
      final dataSource = _FakeCheckoutRemoteDataSource()..orderId = 'order-1';
      final repository = CheckoutRepositoryImpl(dataSource);

      final result = await repository.createOrder(const [
        CheckoutItem(
          productId: 'coffee',
          quantity: 2,
          modifierIds: ['oat', 'shot'],
        ),
      ]);

      expect((result as Success<String>).data, 'order-1');
      expect(dataSource.lastItems, [
        {
          'menu_item_id': 'coffee',
          'quantity': 2,
          'modifier_ids': ['oat', 'shot'],
        },
      ]);
    });

    test('omits modifier_ids when the item has none', () async {
      final dataSource = _FakeCheckoutRemoteDataSource();
      final repository = CheckoutRepositoryImpl(dataSource);

      final result = await repository.createOrder(const [
        CheckoutItem(productId: 'coffee', quantity: 1),
      ]);

      expect(result, isA<Success<String>>());
      expect(dataSource.lastItems, [
        {'menu_item_id': 'coffee', 'quantity': 1},
      ]);
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = CheckoutRepositoryImpl(
        _FakeCheckoutRemoteDataSource()
          ..error = const ConnectionException('offline'),
      );

      final result = await repository.createOrder(const [
        CheckoutItem(productId: 'coffee', quantity: 1),
      ]);

      expect(
        (result as Error<String>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('prefers the server message when the exception carries one', () async {
      final repository = CheckoutRepositoryImpl(
        _FakeCheckoutRemoteDataSource()
          ..error = const ServerException('out of stock'),
      );

      final result = await repository.createOrder(const [
        CheckoutItem(productId: 'coffee', quantity: 1),
      ]);

      expect(
        (result as Error<String>).failure,
        isA<ServerFailure>().having((f) => f.message, 'message', 'out of stock'),
      );
    });

    test('maps a message-less server exception to the creation failure key',
        () async {
      final repository = CheckoutRepositoryImpl(
        _FakeCheckoutRemoteDataSource()..error = const ServerException(),
      );

      final result = await repository.createOrder(const [
        CheckoutItem(productId: 'coffee', quantity: 1),
      ]);

      expect(
        (result as Error<String>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.order_creation_failed',
        ),
      );
    });

    test('maps an unexpected exception to the creation failure key', () async {
      final repository = CheckoutRepositoryImpl(
        _FakeCheckoutRemoteDataSource()..error = StateError('boom'),
      );

      final result = await repository.createOrder(const [
        CheckoutItem(productId: 'coffee', quantity: 1),
      ]);

      expect(
        (result as Error<String>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.order_creation_failed',
        ),
      );
    });
  });

  group('CheckoutRepositoryImpl.payForOrder', () {
    test('forwards the order id and payment method and succeeds', () async {
      final dataSource = _FakeCheckoutRemoteDataSource();
      final repository = CheckoutRepositoryImpl(dataSource);

      final result = await repository.payForOrder('order-1', 'card-1');

      expect(result, isA<Success<void>>());
      expect(dataSource.lastOrderId, 'order-1');
      expect(dataSource.lastPaymentMethod, 'card-1');
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = CheckoutRepositoryImpl(
        _FakeCheckoutRemoteDataSource()
          ..error = const ConnectionException('offline'),
      );

      final result = await repository.payForOrder('order-1', 'wallet');

      expect(
        (result as Error<void>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('prefers the server message when the exception carries one', () async {
      final repository = CheckoutRepositoryImpl(
        _FakeCheckoutRemoteDataSource()
          ..error = const ServerException('card declined'),
      );

      final result = await repository.payForOrder('order-1', 'card-1');

      expect(
        (result as Error<void>).failure,
        isA<ServerFailure>().having((f) => f.message, 'message', 'card declined'),
      );
    });

    test('maps a message-less server exception to the payment failure key',
        () async {
      final repository = CheckoutRepositoryImpl(
        _FakeCheckoutRemoteDataSource()..error = const ServerException(),
      );

      final result = await repository.payForOrder('order-1', 'wallet');

      expect(
        (result as Error<void>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.payment_failed',
        ),
      );
    });

    test('maps an unexpected exception to the payment failure key', () async {
      final repository = CheckoutRepositoryImpl(
        _FakeCheckoutRemoteDataSource()..error = StateError('boom'),
      );

      final result = await repository.payForOrder('order-1', 'wallet');

      expect(
        (result as Error<void>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.payment_failed',
        ),
      );
    });
  });
}

class _FakeCheckoutRemoteDataSource implements CheckoutRemoteDataSource {
  String orderId = 'order-1';
  Object? error;
  List<Map<String, dynamic>>? lastItems;
  String? lastOrderId;
  String? lastPaymentMethod;

  void _maybeThrow() {
    final error = this.error;
    if (error != null) throw error;
  }

  @override
  Future<String> placeOrder({
    required List<Map<String, dynamic>> items,
    String? specialInstructions,
  }) async {
    _maybeThrow();
    lastItems = items;
    return orderId;
  }

  @override
  Future<void> checkoutOrder(
    String orderId, {
    String? paymentMethod,
    String? cardNumber,
  }) async {
    _maybeThrow();
    lastOrderId = orderId;
    lastPaymentMethod = paymentMethod;
  }
}
