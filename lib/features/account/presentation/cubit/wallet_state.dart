import '../../domain/entities/wallet_package.dart';
import '../../domain/entities/wallet_transaction.dart';

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
  final List<WalletTransaction> transactions;

  const WalletLoaded({required this.balance, required this.transactions});
}

final class WalletBalanceLoaded extends WalletState {
  final double balance;

  const WalletBalanceLoaded(this.balance);
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

  /// The packages that were on screen when the error occurred, when known —
  /// lets the sheet keep rendering the list alongside the error.
  final List<WalletPackage>? packages;

  const PackagesError(this.message, {this.packages});
}

final class WalletPhoneUpdated extends WalletState {
  const WalletPhoneUpdated();
}
