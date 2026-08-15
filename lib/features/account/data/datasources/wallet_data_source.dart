import '../models/wallet_package_model.dart';
import '../models/wallet_transaction_model.dart';

abstract class WalletDataSource {
  Future<double> getBalance();
  Future<List<WalletTransactionModel>> getTransactions();
  Future<void> updateWalletPhone(String phone);
  Future<List<WalletPackageModel>> getPackages();
  Future<double?> buyPackage(String packageId);
}
