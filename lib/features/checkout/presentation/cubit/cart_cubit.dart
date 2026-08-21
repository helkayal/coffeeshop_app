import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../menu/domain/entities/product.dart';
import '../../../orders/domain/entities/order_item.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/build_quick_add_item.dart';
import '../../domain/usecases/cart_usecases.dart';
import '../../domain/usecases/place_order.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCart;
  final AddToCartUseCase _addToCart;
  final UpdateCartItemUseCase _updateItem;
  final RemoveCartItemUseCase _removeItem;
  final ClearCartUseCase _clearCart;
  final PlaceOrderUseCase _placeOrder;
  final BuildQuickAddItemUseCase _buildQuickAdd;
  final void Function(ConnectionFailure)? onConnectionFailure;

  CartCubit({
    required GetCartUseCase getCart,
    required AddToCartUseCase addToCart,
    required UpdateCartItemUseCase updateItem,
    required RemoveCartItemUseCase removeItem,
    required ClearCartUseCase clearCart,
    required PlaceOrderUseCase placeOrder,
    required BuildQuickAddItemUseCase buildQuickAddItem,
    this.onConnectionFailure,
  }) : _getCart = getCart,
       _addToCart = addToCart,
       _updateItem = updateItem,
       _removeItem = removeItem,
       _clearCart = clearCart,
       _placeOrder = placeOrder,
       _buildQuickAdd = buildQuickAddItem,
       super(const CartInitial());

  /// Builds a quick-add cart item: last-order selections when reordering,
  /// default options otherwise, plus newly selected extras.
  CartItem buildQuickAddItem(
    Product product, {
    List<OrderItem> lastOrderItems = const [],
    Set<String> selectedExtraIds = const {},
  }) => _buildQuickAdd(
    product,
    lastOrderItems: lastOrderItems,
    selectedExtraIds: selectedExtraIds,
  );

  /// Live unit price for the quick-add sheet (base price + selected extras).
  double quickAddPrice(Product product, {Set<String> selectedExtraIds = const {}}) =>
      _buildQuickAdd.unitPriceFor(product, selectedExtraIds: selectedExtraIds);

  /// Rebuilds a cart item from a previous order line, preserving the
  /// ordered price and quantity.
  CartItem reorderOrderItem(Product product, OrderItem item, {String? productName}) =>
      _buildQuickAdd.fromOrderItem(product, item, productName: productName);

  /// Rebuilds a cart item from an order line without product context.
  CartItem reorderOrderItemRaw(OrderItem item, {required String orderId}) =>
      _buildQuickAdd.fromOrderItemRaw(item, orderId: orderId);

  Future<void> loadCart() async {
    emit(const CartLoading());
    final result = await _getCart();
    if (isClosed) return;
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(CartError(failure.message));
    }, (cart) => emit(CartLoaded(cart)));
  }

  Future<void> addItem(CartItem item) async {
    final current = _currentCart;
    if (current != null) {
      final sortedNew = List<String>.from(item.modifierIds)..sort();
      final existing = current.items.where((i) {
        if (i.productId != item.productId) return false;
        final sortedExisting = List<String>.from(i.modifierIds)..sort();
        if (sortedExisting.length != sortedNew.length) return false;
        for (int j = 0; j < sortedNew.length; j++) {
          if (sortedNew[j] != sortedExisting[j]) return false;
        }
        return true;
      }).firstOrNull;

      if (existing != null) {
        return increment(existing.id);
      }
      emit(CartActionInProgress(current));
    }

    final result = await _addToCart(item);
    if (isClosed) return;
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(CartError(failure.message));
    }, (cart) => emit(CartLoaded(cart)));
  }

  Future<void> increment(String itemId) async {
    final current = _currentCart;
    if (current == null) return;
    final item = current.items.firstWhere((i) => i.id == itemId);
    emit(CartActionInProgress(current));
    final result = await _updateItem(itemId, item.quantity + 1);
    if (isClosed) return;
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(CartError(failure.message));
    }, (cart) => emit(CartLoaded(cart)));
  }

  Future<void> decrement(String itemId) async {
    final current = _currentCart;
    if (current == null) return;
    final item = current.items.firstWhere((i) => i.id == itemId);
    emit(CartActionInProgress(current));
    final result = await _updateItem(itemId, item.quantity - 1);
    if (isClosed) return;
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(CartError(failure.message));
    }, (cart) => emit(CartLoaded(cart)));
  }

  Future<void> remove(String itemId) async {
    final current = _currentCart;
    if (current != null) emit(CartActionInProgress(current));
    final result = await _removeItem(itemId);
    if (isClosed) return;
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(CartError(failure.message));
    }, (cart) => emit(CartLoaded(cart)));
  }

  Future<void> clearCart() async {
    final current = _currentCart;
    if (current != null) emit(CartActionInProgress(current));
    final result = await _clearCart();
    if (isClosed) return;
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(CartError(failure.message));
    }, (_) => emit(CartLoaded(const Cart())));
  }

  Future<void> placeOrder({String paymentMethod = 'wallet'}) async {
    final current = _currentCart;
    if (current == null) return;
    final items = List<CartItem>.from(current.items);
    final total = current.subtotal;
    emit(CartActionInProgress(current));
    final result = await _placeOrder(current, paymentMethod: paymentMethod);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        emit(CartError(failure.message));
      },
      (outcome) {
        final nextState = switch (outcome) {
          OrderCompleted(:final orderId) => OrderPlaced(
            orderId: orderId,
            items: items,
            total: total,
          ),
          OrderPaymentPending(:final orderId, :final failure) =>
            OrderPaymentPendingState(
              orderId: orderId,
              items: items,
              total: total,
              failureCode: failure.message,
            ),
          OrderCleanupWarning(:final orderId, :final failure) =>
            OrderCleanupWarningState(
              orderId: orderId,
              items: items,
              total: total,
              failureCode: failure.message,
            ),
        };
        emit(nextState);
      },
    );
  }

  Cart? get _currentCart {
    final s = state;
    if (s is CartLoaded) return s.cart;
    if (s is CartActionInProgress) return s.cart;
    return null;
  }

  int get itemCount => _currentCart?.itemCount ?? 0;
}
