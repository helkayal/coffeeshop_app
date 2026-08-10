import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remote;

  CartRepositoryImpl(this._remote);

  @override
  Future<Result<Cart>> getCart() async {
    try {
      return Success(await _remote.getCart());
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to load cart'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error loading cart'));
    }
  }

  @override
  Future<Result<Cart>> addItem(CartItem item) async {
    try {
      return Success(await _remote.addItem(item));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to add item'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Result<Cart>> updateQuantity(String itemId, int quantity) async {
    try {
      if (quantity <= 0) {
        return Success(await _remote.removeItem(itemId));
      }
      return Success(await _remote.updateItem(itemId, quantity));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to update item'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Result<Cart>> removeItem(String itemId) async {
    try {
      return Success(await _remote.removeItem(itemId));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to remove item'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error'));
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await _remote.clearCart();
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to clear cart'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Unexpected error'));
    }
  }
}
