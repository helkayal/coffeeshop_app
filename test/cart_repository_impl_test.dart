import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/checkout/data/datasources/cart_remote_data_source.dart';
import 'package:coffeeshop_app/features/checkout/data/repositories/cart_repository_impl.dart';
import 'package:coffeeshop_app/features/checkout/domain/entities/cart.dart';
import 'package:coffeeshop_app/features/checkout/domain/entities/cart_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartRepositoryImpl.getCart', () {
    test('returns the cart from the remote data source', () async {
      final dataSource = _FakeCartRemoteDataSource()..cart = _cart();
      final repository = CartRepositoryImpl(dataSource);

      final result = await repository.getCart();

      expect((result as Success<Cart>).data.itemCount, 2);
    });

    test('maps a server exception to the load failure key', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ServerException(),
      );

      final result = await repository.getCart();

      expect(
        (result as Error<Cart>).failure,
        isA<ServerFailure>().having((f) => f.message, 'message', 'errors.cart_load_failed'),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.getCart();

      expect(
        (result as Error<Cart>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the unexpected error key', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = StateError('boom'),
      );

      final result = await repository.getCart();

      expect(
        (result as Error<Cart>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });

  group('CartRepositoryImpl.addItem', () {
    test('forwards the item and returns the updated cart', () async {
      final dataSource = _FakeCartRemoteDataSource()..cart = _cart();
      final repository = CartRepositoryImpl(dataSource);

      final result = await repository.addItem(_item());

      expect((result as Success<Cart>).data.itemCount, 2);
      expect(dataSource.addedItem?.productId, 'product-1');
    });

    test('maps a server exception to the add failure key', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ServerException(),
      );

      final result = await repository.addItem(_item());

      expect(
        (result as Error<Cart>).failure,
        isA<ServerFailure>().having((f) => f.message, 'message', 'errors.cart_add_failed'),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.addItem(_item());

      expect(
        (result as Error<Cart>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the generic key', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = StateError('boom'),
      );

      final result = await repository.addItem(_item());

      expect(
        (result as Error<Cart>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });

  group('CartRepositoryImpl.updateQuantity', () {
    test('forwards a positive quantity to updateItem', () async {
      final dataSource = _FakeCartRemoteDataSource();
      final repository = CartRepositoryImpl(dataSource);

      final result = await repository.updateQuantity('cart-1', 3);

      expect(result, isA<Success<Cart>>());
      expect(dataSource.updatedItemId, 'cart-1');
      expect(dataSource.updatedQuantity, 3);
      expect(dataSource.removedIds, isEmpty);
    });

    test('removes the item when the quantity is zero or negative', () async {
      final dataSource = _FakeCartRemoteDataSource();
      final repository = CartRepositoryImpl(dataSource);

      final result = await repository.updateQuantity('cart-1', 0);

      expect(result, isA<Success<Cart>>());
      expect(dataSource.removedIds, ['cart-1']);
      expect(dataSource.updatedItemId, isNull);
    });

    test('maps a server exception to the update failure key', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ServerException(),
      );

      final result = await repository.updateQuantity('cart-1', 3);

      expect(
        (result as Error<Cart>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.cart_update_failed',
        ),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.updateQuantity('cart-1', 3);

      expect(
        (result as Error<Cart>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });
  });

  group('CartRepositoryImpl.removeItem', () {
    test('forwards the item id and returns the updated cart', () async {
      final dataSource = _FakeCartRemoteDataSource();
      final repository = CartRepositoryImpl(dataSource);

      final result = await repository.removeItem('cart-1');

      expect(result, isA<Success<Cart>>());
      expect(dataSource.removedIds, ['cart-1']);
    });

    test('maps a server exception to the remove failure key', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ServerException(),
      );

      final result = await repository.removeItem('cart-1');

      expect(
        (result as Error<Cart>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.cart_remove_failed',
        ),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.removeItem('cart-1');

      expect(
        (result as Error<Cart>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the generic key', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = StateError('boom'),
      );

      final result = await repository.removeItem('cart-1');

      expect(
        (result as Error<Cart>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });

  group('CartRepositoryImpl.clearCart', () {
    test('clears the cart through the remote data source', () async {
      final dataSource = _FakeCartRemoteDataSource();
      final repository = CartRepositoryImpl(dataSource);

      final result = await repository.clearCart();

      expect(result, isA<Success<void>>());
      expect(dataSource.clearCalls, 1);
    });

    test('maps a server exception to the clear failure key', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ServerException(),
      );

      final result = await repository.clearCart();

      expect(
        (result as Error<void>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.cart_clear_failed',
        ),
      );
    });

    test('maps a connection exception to a connection failure', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = const ConnectionException('offline'),
      );

      final result = await repository.clearCart();

      expect(
        (result as Error<void>).failure,
        isA<ConnectionFailure>().having((f) => f.message, 'message', 'offline'),
      );
    });

    test('maps an unexpected exception to the generic key', () async {
      final repository = CartRepositoryImpl(
        _FakeCartRemoteDataSource()..error = StateError('boom'),
      );

      final result = await repository.clearCart();

      expect(
        (result as Error<void>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.unexpected_error',
        ),
      );
    });
  });
}

CartItem _item() => const CartItem(
  id: 'cart-1',
  productId: 'product-1',
  name: 'Coffee',
  imagePath: '',
  variant: '',
  unitPrice: 50,
  quantity: 1,
);

Cart _cart() => Cart(items: [_item(), _item()]);

class _FakeCartRemoteDataSource implements CartRemoteDataSource {
  Cart cart = const Cart();
  Object? error;
  CartItem? addedItem;
  String? updatedItemId;
  int? updatedQuantity;
  final removedIds = <String>[];
  int clearCalls = 0;

  void _maybeThrow() {
    final error = this.error;
    if (error != null) throw error;
  }

  @override
  Future<Cart> getCart() async {
    _maybeThrow();
    return cart;
  }

  @override
  Future<Cart> addItem(CartItem item) async {
    _maybeThrow();
    addedItem = item;
    return cart;
  }

  @override
  Future<Cart> updateItem(String itemId, int quantity) async {
    _maybeThrow();
    updatedItemId = itemId;
    updatedQuantity = quantity;
    return cart;
  }

  @override
  Future<Cart> removeItem(String itemId) async {
    _maybeThrow();
    removedIds.add(itemId);
    return cart;
  }

  @override
  Future<void> clearCart() async {
    _maybeThrow();
    clearCalls++;
  }
}
