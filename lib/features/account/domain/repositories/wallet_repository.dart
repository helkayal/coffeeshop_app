import '../../../../core/helpers/result.dart';
import '../../../account/data/models/wallet_package_model.dart';

abstract class WalletRepository {
  Future<Result<double>> getBalance();
  Future<Result<List<Map<String, dynamic>>>> getTransactions();
  Future<Result<void>> updateWalletPhone(String phone);
  Future<Result<List<WalletPackage>>> getPackages();
  Future<Result<double?>> buyPackage(String packageId);
}
