import '../../../account/data/models/wallet_package_model.dart';

abstract class WalletDataSource {
  Future<double> getBalance();
  Future<List<Map<String, dynamic>>> getTransactions();
  Future<void> updateWalletPhone(String phone);
  Future<List<WalletPackage>> getPackages();
  Future<double?> buyPackage(String packageId);
}
