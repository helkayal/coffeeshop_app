import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/checkout/domain/entities/cart.dart';
import 'package:coffeeshop_app/features/checkout/domain/entities/cart_item.dart';
import 'package:coffeeshop_app/features/checkout/domain/repositories/cart_repository.dart';
import 'package:coffeeshop_app/features/checkout/domain/usecases/cart_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetCartUseCase', () {
    test('returns the cart from the repository', () async {
      final repository = _FakeCartRepository()..cart = _cart();

      final result = await GetCartUseCase(repository)();

      expect((result as Success<Cart>).data.itemCount, 2);
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeCartRepository()
        ..failure = const ServerFailure('errors.cart_load_failed');

      final result = await GetCartUseCase(repository)();

      expect(result, isA<Error<Cart>>());
      expect((result as Error<Cart>).failure.message, 'errors.cart_load_failed');
    });
  });

  group('AddToCartUseCase', () {
    test('forwards the item to the repository', () async {
      final repository = _FakeCartRepository();
      final useCase = AddToCartUseCase(repository);

      final result = await useCase(_item());

      expect(result, isA<Success<Cart>>());
      expect(repository.addedItem?.productId, 'product-1');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeCartRepository()
        ..failure = const ServerFailure('errors.cart_add_failed');

      final result = await AddToCartUseCase(repository)(_item());

      expect(result, isA<Error<Cart>>());
      expect((result as Error<Cart>).failure.message, 'errors.cart_add_failed');
    });
  });

  group('UpdateCartItemUseCase', () {
    test('forwards the item id and quantity to the repository', () async {
      final repository = _FakeCartRepository();
      final useCase = UpdateCartItemUseCase(repository);

      final result = await useCase('cart-1', 3);

      expect(result, isA<Success<Cart>>());
      expect(repository.updatedId, 'cart-1');
      expect(repository.updatedQuantity, 3);
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeCartRepository()
        ..failure = const ServerFailure('errors.unexpected_error');

      final result = await UpdateCartItemUseCase(repository)('cart-1', 3);

      expect(result, isA<Error<Cart>>());
      expect(
        (result as Error<Cart>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('RemoveCartItemUseCase', () {
    test('forwards the item id to the repository', () async {
      final repository = _FakeCartRepository();
      final useCase = RemoveCartItemUseCase(repository);

      final result = await useCase('cart-1');

      expect(result, isA<Success<Cart>>());
      expect(repository.removedId, 'cart-1');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeCartRepository()
        ..failure = const ServerFailure('errors.cart_remove_failed');

      final result = await RemoveCartItemUseCase(repository)('cart-1');

      expect(result, isA<Error<Cart>>());
      expect(
        (result as Error<Cart>).failure.message,
        'errors.cart_remove_failed',
      );
    });
  });

  group('ClearCartUseCase', () {
    test('clears the cart through the repository', () async {
      final repository = _FakeCartRepository();
      final useCase = ClearCartUseCase(repository);

      final result = await useCase();

      expect(result, isA<Success<void>>());
      expect(repository.clearCalls, 1);
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakeCartRepository()
        ..failure = const CacheFailure('errors.cart_clear_failed');

      final result = await ClearCartUseCase(repository)();

      expect(result, isA<Error<void>>());
      expect(
        (result as Error<void>).failure.message,
        'errors.cart_clear_failed',
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

class _FakeCartRepository implements CartRepository {
  Cart cart = const Cart();
  Failure? failure;
  CartItem? addedItem;
  String? updatedId;
  int? updatedQuantity;
  String? removedId;
  int clearCalls = 0;

  @override
  Future<Result<Cart>> getCart() async {
    final failure = this.failure;
    return failure == null ? Success(cart) : Error(failure);
  }

  @override
  Future<Result<Cart>> addItem(CartItem item) async {
    addedItem = item;
    final failure = this.failure;
    return failure == null ? Success(cart) : Error(failure);
  }

  @override
  Future<Result<Cart>> updateQuantity(String itemId, int quantity) async {
    updatedId = itemId;
    updatedQuantity = quantity;
    final failure = this.failure;
    return failure == null ? Success(cart) : Error(failure);
  }

  @override
  Future<Result<Cart>> removeItem(String itemId) async {
    removedId = itemId;
    final failure = this.failure;
    return failure == null ? Success(cart) : Error(failure);
  }

  @override
  Future<Result<void>> clearCart() async {
    clearCalls++;
    final failure = this.failure;
    return failure == null ? const Success(null) : Error(failure);
  }
}
