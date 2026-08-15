import 'dart:async';

import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/account/domain/entities/wallet_package.dart';
import 'package:coffeeshop_app/features/account/domain/entities/wallet_transaction.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/wallet_repository.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/wallet_usecases.dart';
import 'package:coffeeshop_app/features/account/presentation/cubit/wallet_cubit.dart';
import 'package:coffeeshop_app/features/account/presentation/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opening wallet screen starts loading wallet data', (
    tester,
  ) async {
    final repository = _PendingWalletRepository();
    final cubit = WalletCubit(
      getBalance: GetWalletBalanceUseCase(repository),
      getTransactions: GetWalletTransactionsUseCase(repository),
      updatePhone: UpdateWalletPhoneUseCase(repository),
      getPackages: GetWalletPackagesUseCase(repository),
      buyPackage: BuyWalletPackageUseCase(repository),
    );

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const MaterialApp(home: WalletScreen()),
      ),
    );
    await tester.pump();

    expect(repository.balanceCalls, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await cubit.close();
  });
}

class _PendingWalletRepository implements WalletRepository {
  final _balance = Completer<Result<double>>();
  int balanceCalls = 0;

  @override
  Future<Result<double>> getBalance() {
    balanceCalls++;
    return _balance.future;
  }

  @override
  Future<Result<List<WalletTransaction>>> getTransactions() async =>
      const Success([]);

  @override
  Future<Result<void>> updateWalletPhone(String phone) async =>
      const Success(null);

  @override
  Future<Result<List<WalletPackage>>> getPackages() async => const Success([]);

  @override
  Future<Result<double?>> buyPackage(String packageId) async =>
      const Success(null);
}
