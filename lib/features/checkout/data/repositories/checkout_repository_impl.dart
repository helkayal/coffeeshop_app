import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/checkout_item.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_data_source.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource _remote;

  const CheckoutRepositoryImpl(this._remote);

  @override
  Future<Result<String>> createOrder(List<CheckoutItem> items) async {
    try {
      return Success(
        await _remote.placeOrder(
          items: items
              .map(
                (item) => <String, dynamic>{
                  'menu_item_id': item.productId,
                  'quantity': item.quantity,
                  if (item.modifierIds.isNotEmpty)
                    'modifier_ids': item.modifierIds,
                },
              )
              .toList(growable: false),
        ),
      );
    } on ConnectionException catch (error) {
      return Error(ConnectionFailure(error.message));
    } on ServerException catch (error) {
      return Error(ServerFailure(error.message ?? 'order_creation_failed'));
    } catch (_) {
      return const Error(ServerFailure('order_creation_failed'));
    }
  }

  @override
  Future<Result<void>> payForOrder(String orderId, String paymentMethod) async {
    try {
      await _remote.checkoutOrder(orderId, paymentMethod: paymentMethod);
      return const Success(null);
    } on ConnectionException catch (error) {
      return Error(ConnectionFailure(error.message));
    } on ServerException catch (error) {
      return Error(ServerFailure(error.message ?? 'payment_failed'));
    } catch (_) {
      return const Error(ServerFailure('payment_failed'));
    }
  }
}
