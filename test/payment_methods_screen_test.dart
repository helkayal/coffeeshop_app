import 'dart:convert';
import 'dart:io';

import 'package:coffeeshop_app/core/cubit/connectivity_cubit.dart';
import 'package:coffeeshop_app/core/entities/connection_status.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/core/services/network_info_service.dart';
import 'package:coffeeshop_app/features/account/domain/entities/payment_method.dart';
import 'package:coffeeshop_app/features/account/domain/entities/payment_preferences.dart';
import 'package:coffeeshop_app/features/account/domain/entities/wallet_package.dart';
import 'package:coffeeshop_app/features/account/domain/entities/wallet_transaction.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/payment_methods_repository.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/payment_preferences_repository.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/wallet_repository.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/payment_methods_usecases.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/payment_preferences_usecases.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/wallet_usecases.dart';
import 'package:coffeeshop_app/features/account/presentation/cubit/payment_methods_cubit.dart';
import 'package:coffeeshop_app/features/account/presentation/cubit/payment_preferences_cubit.dart';
import 'package:coffeeshop_app/features/account/presentation/screens/payment_methods_screen.dart';
import 'package:coffeeshop_app/features/checkout/presentation/widgets/payment_option.dart';
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
  // Option order in the screen: wallet (0), apple pay (1), then saved cards.
  Finder checkedRadioInOption(int index) => find.descendant(
    of: find.byType(PaymentOption).at(index),
    matching: find.byIcon(Icons.radio_button_checked),
  );

  Future<void> pumpScreen(
    WidgetTester tester,
    _FakePaymentPreferencesRepository preferencesRepository, {
    List<PaymentMethod> cards = const [],
  }) async {
    final paymentMethodsCubit = PaymentMethodsCubit(
      getMethods: GetPaymentMethodsUseCase(
        _FakePaymentMethodsRepository(cards),
      ),
      addCard: AddCardUseCase(_FakePaymentMethodsRepository(cards)),
      deleteCard: DeleteCardUseCase(_FakePaymentMethodsRepository(cards)),
    );
    final preferencesCubit = PaymentPreferencesCubit(
      getPreferences: GetPaymentPreferencesUseCase(preferencesRepository),
      setDefaultMethod: SetDefaultPaymentMethodUseCase(preferencesRepository),
      setWalletPhone: SetWalletPhoneUseCase(preferencesRepository),
      updateWalletPhone: UpdateWalletPhoneUseCase(_UnusedWalletRepository()),
    )..load();
    final connectivityCubit = ConnectivityCubit(_FakeNetworkInfoService());

    addTearDown(() async {
      await paymentMethodsCubit.close();
      await preferencesCubit.close();
      await connectivityCubit.close();
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
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: paymentMethodsCubit),
                BlocProvider.value(value: preferencesCubit),
                BlocProvider.value(value: connectivityCubit),
              ],
              child: const PaymentMethodsScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'wallet stays the only selected option when a card is marked default '
    'on the server',
    (tester) async {
      final preferencesRepository = _FakePaymentPreferencesRepository(
        defaultMethod: 'wallet',
      );

      await pumpScreen(
        tester,
        preferencesRepository,
        cards: const [
          PaymentMethod(
            id: 'card-a',
            lastFour: '4242',
            expiryMonth: 12,
            expiryYear: 2027,
            brand: 'visa',
            isDefault: true,
          ),
          PaymentMethod(
            id: 'card-b',
            lastFour: '1111',
            expiryMonth: 6,
            expiryYear: 2028,
            brand: 'mastercard',
            isDefault: false,
          ),
        ],
      );

      // One radio group: exactly one option selected, and it is the wallet.
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      expect(checkedRadioInOption(0), findsOneWidget);
      expect(find.text('Default'), findsNothing);
    },
  );

  testWidgets('tapping a card moves the single selection to that card', (
    tester,
  ) async {
    final preferencesRepository = _FakePaymentPreferencesRepository(
      defaultMethod: 'wallet',
    );

    await pumpScreen(
      tester,
      preferencesRepository,
      cards: const [
        PaymentMethod(
          id: 'card-a',
          lastFour: '4242',
          expiryMonth: 12,
          expiryYear: 2027,
          brand: 'visa',
          isDefault: false,
        ),
        PaymentMethod(
          id: 'card-b',
          lastFour: '1111',
          expiryMonth: 6,
          expiryYear: 2028,
          brand: 'mastercard',
          isDefault: false,
        ),
      ],
    );

    await tester.tap(find.byType(PaymentOption).at(3));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    expect(checkedRadioInOption(0), findsNothing);
    expect(checkedRadioInOption(3), findsOneWidget);
    expect(preferencesRepository.defaultMethod, 'card-b');
  });

  testWidgets('tapping apple pay moves the single selection to it', (
    tester,
  ) async {
    final preferencesRepository = _FakePaymentPreferencesRepository(
      defaultMethod: 'wallet',
    );

    await pumpScreen(tester, preferencesRepository);

    await tester.tap(find.byType(PaymentOption).at(1));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    expect(checkedRadioInOption(0), findsNothing);
    expect(checkedRadioInOption(1), findsOneWidget);
    expect(preferencesRepository.defaultMethod, 'applepay');
  });
}

class _FakePaymentPreferencesRepository implements PaymentPreferencesRepository {
  _FakePaymentPreferencesRepository({this.defaultMethod});

  String? defaultMethod;

  @override
  Future<Result<PaymentPreferences>> getPreferences() async => Success(
    PaymentPreferences(defaultMethod: defaultMethod, walletPhone: '01000000000'),
  );

  @override
  Future<Result<void>> setDefaultMethod(String method) async {
    defaultMethod = method;
    return const Success(null);
  }

  @override
  Future<Result<void>> setWalletPhone(String phone) async =>
      const Success(null);
}

class _FakePaymentMethodsRepository implements PaymentMethodsRepository {
  _FakePaymentMethodsRepository(this.cards);

  final List<PaymentMethod> cards;

  @override
  Future<Result<List<PaymentMethod>>> getPaymentMethods() async =>
      Success(cards);

  @override
  Future<Result<void>> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  }) async => const Success(null);

  @override
  Future<Result<void>> deleteCard(String cardId) async => const Success(null);
}

class _UnusedWalletRepository implements WalletRepository {
  @override
  Future<Result<double>> getBalance() => throw UnimplementedError();

  @override
  Future<Result<List<WalletTransaction>>> getTransactions() =>
      throw UnimplementedError();

  @override
  Future<Result<void>> updateWalletPhone(String phone) =>
      throw UnimplementedError();

  @override
  Future<Result<List<WalletPackage>>> getPackages() =>
      throw UnimplementedError();

  @override
  Future<Result<double?>> buyPackage(String packageId) =>
      throw UnimplementedError();
}

class _FakeNetworkInfoService implements NetworkInfoService {
  @override
  Future<ConnectionStatus> checkConnectivity() async =>
      ConnectionStatus.connected;

  @override
  Future<bool> hasInternetConnection() async => true;

  @override
  Future<bool> isServerReachable() async => true;
}
