import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _local;

  CartRepositoryImpl(this._local);

  @override
  Future<Result<Cart>> getCart() async {
    try {
      return Success(await _local.getCart());
    } on CacheException catch (e) {
      return Error(CacheFailure(e.message ?? 'Failed to load cart'));
    } catch (_) {
      return const Error(CacheFailure('Unexpected error loading cart'));
    }
  }

  @override
  Future<Result<Cart>> addItem(CartItem item) async {
    try {
      final cart = await _local.getCart();
      final existingIndex =
          cart.items.indexWhere((i) => i.id == item.id);

      if (existingIndex >= 0) {
        // Increment quantity if same item already in cart.
        final existing = cart.items[existingIndex];
        await _local.saveItem(existing.copyWith(
          quantity: existing.quantity + item.quantity,
        ));
      } else {
        await _local.saveItem(item);
      }
      return Success(await _local.getCart());
    } on CacheException catch (e) {
      return Error(CacheFailure(e.message ?? 'Failed to add item'));
    } catch (_) {
      return const Error(CacheFailure('Unexpected error'));
    }
  }

  @override
  Future<Result<Cart>> updateQuantity(String itemId, int quantity) async {
    try {
      if (quantity <= 0) {
        await _local.deleteItem(itemId);
      } else {
        final cart = await _local.getCart();
        final item = cart.items.firstWhere((i) => i.id == itemId);
        await _local.saveItem(item.copyWith(quantity: quantity));
      }
      return Success(await _local.getCart());
    } on CacheException catch (e) {
      return Error(CacheFailure(e.message ?? 'Failed to update item'));
    } catch (_) {
      return const Error(CacheFailure('Unexpected error'));
    }
  }

  @override
  Future<Result<Cart>> removeItem(String itemId) async {
    try {
      await _local.deleteItem(itemId);
      return Success(await _local.getCart());
    } on CacheException catch (e) {
      return Error(CacheFailure(e.message ?? 'Failed to remove item'));
    } catch (_) {
      return const Error(CacheFailure('Unexpected error'));
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await _local.clearCart();
      return const Success(null);
    } on CacheException catch (e) {
      return Error(CacheFailure(e.message ?? 'Failed to clear cart'));
    } catch (_) {
      return const Error(CacheFailure('Unexpected error'));
    }
  }
}
