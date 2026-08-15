import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../data/datasources/wallet_data_source.dart';
import '../../domain/entities/wallet_package.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletDataSource _dataSource;

  WalletRepositoryImpl(this._dataSource);

  @override
  Future<Result<double>> getBalance() async {
    try {
      return Success(await _dataSource.getBalance());
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Failed to load wallet balance'));
    }
  }

  @override
  Future<Result<List<WalletTransaction>>> getTransactions() async {
    try {
      return Success(await _dataSource.getTransactions());
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Failed to load transactions'));
    }
  }

  @override
  Future<Result<void>> updateWalletPhone(String phone) async {
    try {
      await _dataSource.updateWalletPhone(phone);
      return const Success(null);
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Failed to update wallet phone'));
    }
  }

  @override
  Future<Result<List<WalletPackage>>> getPackages() async {
    try {
      return Success(await _dataSource.getPackages());
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Failed to load packages'));
    }
  }

  @override
  Future<Result<double?>> buyPackage(String packageId) async {
    try {
      return Success(await _dataSource.buyPackage(packageId));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Purchase failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      return const Error(ServerFailure('Purchase failed. Please try again.'));
    }
  }
}
