import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/checkout/domain/entities/cart.dart';
import 'package:coffeeshop_app/features/checkout/domain/entities/cart_item.dart';
import 'package:coffeeshop_app/features/checkout/domain/entities/checkout_item.dart';
import 'package:coffeeshop_app/features/checkout/domain/repositories/cart_repository.dart';
import 'package:coffeeshop_app/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:coffeeshop_app/features/checkout/domain/usecases/place_order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeCartRepository cartRepository;
  late _FakeCheckoutRepository checkoutRepository;
  late PlaceOrderUseCase useCase;

  setUp(() {
    cartRepository = _FakeCartRepository();
    checkoutRepository = _FakeCheckoutRepository();
    useCase = PlaceOrderUseCase(cartRepository, checkoutRepository);
  });

  test('rejects an empty cart', () async {
    final result = await useCase(const Cart());

    expect(result, isA<Error<PlaceOrderOutcome>>());
    expect(checkoutRepository.createCalls, 0);
  });

  test('returns completed and clears cart after successful payment', () async {
    final result = await useCase(_cart());

    expect((result as Success<PlaceOrderOutcome>).data, isA<OrderCompleted>());
    expect(cartRepository.removedIds, ['cart-item']);
  });

  test(
    'preserves cart and reports payment pending on payment failure',
    () async {
      checkoutRepository.paymentFailure = const ServerFailure('payment_failed');

      final result = await useCase(_cart());

      expect(
        (result as Success<PlaceOrderOutcome>).data,
        isA<OrderPaymentPending>(),
      );
      expect(cartRepository.removedIds, isEmpty);
    },
  );

  test('reports cleanup warning after successful order and payment', () async {
    cartRepository.removeFailure = const CacheFailure('cleanup_failed');

    final result = await useCase(_cart());

    expect(
      (result as Success<PlaceOrderOutcome>).data,
      isA<OrderCleanupWarning>(),
    );
  });

  test('propagates order creation failure without changing cart', () async {
    checkoutRepository.creationFailure = const ServerFailure(
      'order_creation_failed',
    );

    final result = await useCase(_cart());

    expect(result, isA<Error<PlaceOrderOutcome>>());
    expect(cartRepository.removedIds, isEmpty);
  });
}

Cart _cart() => const Cart(
  items: [
    CartItem(
      id: 'cart-item',
      productId: 'product-1',
      name: 'Coffee',
      imagePath: '',
      variant: '',
      unitPrice: 50,
      quantity: 1,
    ),
  ],
);

class _FakeCheckoutRepository implements CheckoutRepository {
  Failure? creationFailure;
  Failure? paymentFailure;
  int createCalls = 0;

  @override
  Future<Result<String>> createOrder(List<CheckoutItem> items) async {
    createCalls++;
    final failure = creationFailure;
    return failure == null ? const Success('order-1') : Error(failure);
  }

  @override
  Future<Result<void>> payForOrder(String orderId, String paymentMethod) async {
    final failure = paymentFailure;
    return failure == null ? const Success(null) : Error(failure);
  }
}

class _FakeCartRepository implements CartRepository {
  Failure? removeFailure;
  final removedIds = <String>[];

  @override
  Future<Result<Cart>> removeItem(String itemId) async {
    final failure = removeFailure;
    if (failure != null) return Error(failure);
    removedIds.add(itemId);
    return const Success(Cart());
  }

  @override
  Future<Result<Cart>> addItem(CartItem item) => throw UnimplementedError();

  @override
  Future<Result<void>> clearCart() => throw UnimplementedError();

  @override
  Future<Result<Cart>> getCart() => throw UnimplementedError();

  @override
  Future<Result<Cart>> updateQuantity(String itemId, int quantity) =>
      throw UnimplementedError();
}
