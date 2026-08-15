import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/wallet_usecases.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final GetWalletBalanceUseCase _getBalance;
  final GetWalletTransactionsUseCase _getTransactions;
  final UpdateWalletPhoneUseCase _updatePhone;
  final GetWalletPackagesUseCase _getPackages;
  final BuyWalletPackageUseCase _buyPackage;
  final void Function(ConnectionFailure)? onConnectionFailure;

  WalletCubit({
    required GetWalletBalanceUseCase getBalance,
    required GetWalletTransactionsUseCase getTransactions,
    required UpdateWalletPhoneUseCase updatePhone,
    required GetWalletPackagesUseCase getPackages,
    required BuyWalletPackageUseCase buyPackage,
    this.onConnectionFailure,
  }) : _getBalance = getBalance,
       _getTransactions = getTransactions,
       _updatePhone = updatePhone,
       _getPackages = getPackages,
       _buyPackage = buyPackage,
       super(const WalletInitial());

  Future<void> loadWallet() async {
    emit(const WalletLoading());
    final balResult = await _getBalance();
    final txnResult = await _getTransactions();

    balResult.fold(
      (failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        emit(WalletError(failure.message));
      },
      (balance) => txnResult.fold((failure) {
        if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
        emit(WalletError(failure.message));
      }, (txns) => emit(WalletLoaded(balance: balance, transactions: txns))),
    );
  }

  Future<void> loadBalance() async {
    emit(const WalletLoading());
    final result = await _getBalance();
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(WalletError(failure.message));
    }, (balance) => emit(WalletBalanceLoaded(balance)));
  }

  Future<void> updateWalletPhone(String phone) async {
    final result = await _updatePhone(phone);
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (_) => emit(const WalletPhoneUpdated()),
    );
  }

  Future<void> loadPackages() async {
    emit(const PackagesLoading());
    final result = await _getPackages();
    result.fold((failure) {
      if (failure is ConnectionFailure) onConnectionFailure?.call(failure);
      emit(PackagesError(failure.message));
    }, (packages) => emit(PackagesLoaded(packages)));
  }

  Future<void> buyPackage(String packageId) async {
    final current = state;
    if (current is PackagesLoaded) {
      emit(PackagesBuyInProgress(current.packages));
    }
    final result = await _buyPackage(packageId);
    result.fold(
      (failure) => emit(PackagesError(failure.message)),
      (newBalance) => emit(PackagePurchased(newBalance)),
    );
  }
}
