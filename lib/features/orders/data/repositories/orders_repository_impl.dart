import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_data_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersDataSource _dataSource;

  OrdersRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<Order>>> getOrders() async {
    try {
      final orders = await _dataSource.getOrders();
      return Success(List<Order>.from(orders));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.orders_load_failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }

  @override
  Future<Result<Order>> getOrderById(String id) async {
    try {
      return Success(await _dataSource.getOrderById(id));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'errors.order_not_found'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('errors.unexpected_error'));
    }
  }
}
