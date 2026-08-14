import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../data/datasources/payment_methods_data_source.dart';
import '../../domain/repositories/payment_methods_repository.dart';

class PaymentMethodsRepositoryImpl implements PaymentMethodsRepository {
  final PaymentMethodsDataSource _dataSource;

  PaymentMethodsRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<Map<String, dynamic>>>> getPaymentMethods() async {
    try {
      return Success(await _dataSource.getPaymentMethods());
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Failed to load payment methods'));
    }
  }

  @override
  Future<Result<void>> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  }) async {
    try {
      await _dataSource.addCard(
        number: number,
        expiry: expiry,
        cvv: cvv,
        name: name,
      );
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to add card'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Failed to add card'));
    }
  }

  @override
  Future<Result<void>> deleteCard(String cardId) async {
    try {
      await _dataSource.deleteCard(cardId);
      return const Success(null);
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Failed to delete card'));
    }
  }
}
