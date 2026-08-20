import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coffeeshop_app/core/cubit/shell_cubit.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/account/domain/entities/loyalty_history_entry.dart';
import 'package:coffeeshop_app/features/account/domain/entities/payment_method.dart';
import 'package:coffeeshop_app/features/account/domain/entities/payment_preferences.dart';
import 'package:coffeeshop_app/features/account/domain/entities/user_profile.dart';
import 'package:coffeeshop_app/features/account/domain/entities/wallet_package.dart';
import 'package:coffeeshop_app/features/account/domain/entities/wallet_transaction.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/payment_methods_repository.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/payment_preferences_repository.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/profile_repository.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/wallet_repository.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/payment_methods_usecases.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/payment_preferences_usecases.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/profile_usecases.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/wallet_usecases.dart';
import 'package:coffeeshop_app/features/account/presentation/cubit/payment_methods_cubit.dart';
import 'package:coffeeshop_app/features/account/presentation/cubit/payment_preferences_cubit.dart';
import 'package:coffeeshop_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:coffeeshop_app/features/account/presentation/cubit/wallet_cubit.dart';
import 'package:coffeeshop_app/features/account/presentation/widgets/package_selection_sheet.dart';
import 'package:coffeeshop_app/features/account/presentation/widgets/wallet_package_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reads translation JSONs synchronously so they load inside the widget
/// test's fake-async zone, where rootBundle asset loading hangs.
class _FileAssetLoader extends AssetLoader {
  const _FileAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final file = File(
      '$path/${locale.toStringWithSeparator(separator: '-')}.json',
    );
    return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}

void main() {
  Future<void> pumpSheetHost(
    WidgetTester tester,
    _FakeWalletRepository walletRepository, {
    double requiredAmount = 100,
  }) async {
    final walletCubit = WalletCubit(
      getBalance: GetWalletBalanceUseCase(walletRepository),
      getTransactions: GetWalletTransactionsUseCase(walletRepository),
      updatePhone: UpdateWalletPhoneUseCase(walletRepository),
      getPackages: GetWalletPackagesUseCase(walletRepository),
      buyPackage: BuyWalletPackageUseCase(walletRepository),
    );
    final paymentMethodsCubit = PaymentMethodsCubit(
      getMethods: GetPaymentMethodsUseCase(_UnusedPaymentMethodsRepository()),
      addCard: AddCardUseCase(_UnusedPaymentMethodsRepository()),
      deleteCard: DeleteCardUseCase(_UnusedPaymentMethodsRepository()),
    );
    final preferencesCubit = PaymentPreferencesCubit(
      getPreferences: GetPaymentPreferencesUseCase(
        _UnusedPaymentPreferencesRepository(),
      ),
      setDefaultMethod: SetDefaultPaymentMethodUseCase(
        _UnusedPaymentPreferencesRepository(),
      ),
      setWalletPhone: SetWalletPhoneUseCase(
        _UnusedPaymentPreferencesRepository(),
      ),
      updateWalletPhone: UpdateWalletPhoneUseCase(walletRepository),
    );
    final profileCubit = ProfileCubit(
      getProfile: GetProfileUseCase(_UnusedProfileRepository()),
      updateProfile: UpdateProfileUseCase(_UnusedProfileRepository()),
      getLoyaltyPoints: GetLoyaltyPointsUseCase(_UnusedProfileRepository()),
      uploadAvatar: UploadAvatarUseCase(_UnusedProfileRepository()),
      changeEmail: ChangeEmailUseCase(_UnusedProfileRepository()),
    );
    final shellCubit = ShellCubit();

    addTearDown(() async {
      await walletCubit.close();
      await paymentMethodsCubit.close();
      await preferencesCubit.close();
      await profileCubit.close();
      await shellCubit.close();
    });

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        startLocale: const Locale('en'),
        fallbackLocale: const Locale('en'),
        assetLoader: const _FileAssetLoader(),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            // Mirrors MainShell: cubits are provided below the navigator,
            // so modal sheet content cannot see them unless the sheet
            // re-provides them inside its own route.
            home: Scaffold(
              body: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: walletCubit),
                  BlocProvider.value(value: paymentMethodsCubit),
                  BlocProvider.value(value: preferencesCubit),
                  BlocProvider.value(value: profileCubit),
                  BlocProvider.value(value: shellCubit),
                ],
                child: Builder(
                  builder: (context) => Center(
                    child: ElevatedButton(
                      onPressed: () => PackageSelectionSheet.show(
                        context,
                        requiredAmount: requiredAmount,
                      ),
                      child: const Text('open'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder checkedIconInTile(int index) => find.descendant(
    of: find.byType(WalletPackageTile).at(index),
    matching: find.byIcon(Icons.radio_button_checked),
  );

  testWidgets(
    'package selection sheet opens from a context whose providers are below '
    'the navigator',
    (tester) async {
      final walletRepository = _FakeWalletRepository();
      await pumpSheetHost(tester, walletRepository);

      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.takeException(), isNull);
      expect(walletRepository.packageCalls, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('selects the cheapest package that covers the required amount', (
    tester,
  ) async {
    final walletRepository = _FakeWalletRepository(
      packages: const [
        WalletPackage(
          id: 'p1',
          name: 'Starter',
          amount: 50,
          loyaltyPoints: 100,
        ),
        WalletPackage(
          id: 'p2',
          name: 'Standard',
          amount: 100,
          loyaltyPoints: 250,
        ),
        WalletPackage(
          id: 'p3',
          name: 'Premium',
          amount: 200,
          loyaltyPoints: 600,
        ),
      ],
    );
    await pumpSheetHost(tester, walletRepository, requiredAmount: 100);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(WalletPackageTile), findsNWidgets(3));
    expect(checkedIconInTile(1), findsOneWidget);
  });

  testWidgets(
    'falls back to the first package when none covers the required amount',
    (tester) async {
      final walletRepository = _FakeWalletRepository(
        packages: const [
          WalletPackage(
            id: 'p1',
            name: 'Starter',
            amount: 50,
            loyaltyPoints: 100,
          ),
          WalletPackage(
            id: 'p2',
            name: 'Standard',
            amount: 75,
            loyaltyPoints: 180,
          ),
        ],
      );
      await pumpSheetHost(tester, walletRepository, requiredAmount: 100);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(WalletPackageTile), findsNWidgets(2));
      expect(checkedIconInTile(0), findsOneWidget);
    },
  );
}

class _FakeWalletRepository implements WalletRepository {
  _FakeWalletRepository({this.packages});

  /// When null, getPackages stays pending (loading spinner state).
  final List<WalletPackage>? packages;
  final _pendingPackages = Completer<Result<List<WalletPackage>>>();
  int packageCalls = 0;

  @override
  Future<Result<double>> getBalance() async => const Success(0);

  @override
  Future<Result<List<WalletTransaction>>> getTransactions() async =>
      const Success([]);

  @override
  Future<Result<void>> updateWalletPhone(String phone) async =>
      const Success(null);

  @override
  Future<Result<List<WalletPackage>>> getPackages() {
    packageCalls++;
    final loaded = packages;
    if (loaded != null) return Future.value(Success(loaded));
    return _pendingPackages.future;
  }

  @override
  Future<Result<double?>> buyPackage(String packageId) async =>
      const Success(null);
}

class _UnusedPaymentMethodsRepository implements PaymentMethodsRepository {
  @override
  Future<Result<List<PaymentMethod>>> getPaymentMethods() =>
      throw UnimplementedError();

  @override
  Future<Result<void>> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  }) => throw UnimplementedError();

  @override
  Future<Result<void>> deleteCard(String cardId) => throw UnimplementedError();
}

class _UnusedPaymentPreferencesRepository
    implements PaymentPreferencesRepository {
  @override
  Future<Result<PaymentPreferences>> getPreferences() =>
      throw UnimplementedError();

  @override
  Future<Result<void>> setDefaultMethod(String method) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> setWalletPhone(String phone) =>
      throw UnimplementedError();
}

class _UnusedProfileRepository implements ProfileRepository {
  @override
  Future<Result<UserProfile>> getProfile() => throw UnimplementedError();

  @override
  Future<Result<UserProfile>> updateProfile(UserProfile profile) =>
      throw UnimplementedError();

  @override
  Future<Result<double>> getLoyaltyPoints() => throw UnimplementedError();

  @override
  Future<Result<List<LoyaltyHistoryEntry>>> getLoyaltyHistory() =>
      throw UnimplementedError();

  @override
  Future<Result<String?>> uploadAvatar(String filePath) =>
      throw UnimplementedError();

  @override
  Future<Result<void>> changeEmail(String newEmail, String password) =>
      throw UnimplementedError();
}
