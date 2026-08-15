import '../../../../core/helpers/result.dart';
import '../entities/wallet_package.dart';
import '../entities/wallet_transaction.dart';

abstract class WalletRepository {
  Future<Result<double>> getBalance();
  Future<Result<List<WalletTransaction>>> getTransactions();
  Future<Result<void>> updateWalletPhone(String phone);
  Future<Result<List<WalletPackage>>> getPackages();
  Future<Result<double?>> buyPackage(String packageId);
}
