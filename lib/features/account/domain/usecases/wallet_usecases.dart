import '../../../../core/helpers/result.dart';
import '../entities/wallet_package.dart';
import '../entities/wallet_transaction.dart';
import '../repositories/wallet_repository.dart';

class GetWalletBalanceUseCase {
  final WalletRepository _repository;
  const GetWalletBalanceUseCase(this._repository);
  Future<Result<double>> call() => _repository.getBalance();
}

class GetWalletTransactionsUseCase {
  final WalletRepository _repository;
  const GetWalletTransactionsUseCase(this._repository);
  Future<Result<List<WalletTransaction>>> call() =>
      _repository.getTransactions();
}

class UpdateWalletPhoneUseCase {
  final WalletRepository _repository;
  const UpdateWalletPhoneUseCase(this._repository);
  Future<Result<void>> call(String phone) =>
      _repository.updateWalletPhone(phone);
}

class GetWalletPackagesUseCase {
  final WalletRepository _repository;
  const GetWalletPackagesUseCase(this._repository);
  Future<Result<List<WalletPackage>>> call() => _repository.getPackages();
}

class BuyWalletPackageUseCase {
  final WalletRepository _repository;
  const BuyWalletPackageUseCase(this._repository);
  Future<Result<double?>> call(String packageId) =>
      _repository.buyPackage(packageId);
}
