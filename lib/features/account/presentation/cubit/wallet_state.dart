import '../../../account/data/models/wallet_package_model.dart';

sealed class WalletState {
  const WalletState();
}

final class WalletInitial extends WalletState {
  const WalletInitial();
}

final class WalletLoading extends WalletState {
  const WalletLoading();
}

final class WalletLoaded extends WalletState {
  final double balance;
  final List<Map<String, dynamic>> transactions;

  const WalletLoaded({required this.balance, required this.transactions});
}

final class WalletError extends WalletState {
  final String message;
  const WalletError(this.message);
}

final class PackagesLoading extends WalletState {
  const PackagesLoading();
}

final class PackagesLoaded extends WalletState {
  final List<WalletPackage> packages;
  const PackagesLoaded(this.packages);
}

final class PackagesBuyInProgress extends WalletState {
  final List<WalletPackage> packages;
  const PackagesBuyInProgress(this.packages);
}

final class PackagePurchased extends WalletState {
  final double? newBalance;
  const PackagePurchased(this.newBalance);
}

final class PackagesError extends WalletState {
  final String message;
  const PackagesError(this.message);
}

final class WalletPhoneUpdated extends WalletState {
  const WalletPhoneUpdated();
}
