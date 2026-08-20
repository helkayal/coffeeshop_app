import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/account/data/datasources/payment_methods_data_source.dart';
import 'package:coffeeshop_app/features/account/data/datasources/wallet_data_source.dart';
import 'package:coffeeshop_app/features/account/data/models/payment_method_model.dart';
import 'package:coffeeshop_app/features/account/data/models/wallet_package_model.dart';
import 'package:coffeeshop_app/features/account/data/models/wallet_transaction_model.dart';
import 'package:coffeeshop_app/features/account/data/repositories/payment_methods_repository_impl.dart';
import 'package:coffeeshop_app/features/account/data/repositories/wallet_repository_impl.dart';
import 'package:coffeeshop_app/features/account/domain/entities/payment_method.dart';
import 'package:coffeeshop_app/features/account/domain/entities/wallet_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WalletRepositoryImpl.getPackages', () {
    test('returns plain entity instances, not models', () async {
      final repository = WalletRepositoryImpl(
        _StubWalletDataSource(
          packages: [
            const WalletPackageModel(
              id: 'p1',
              name: 'Starter',
              amount: 100,
              loyaltyPoints: 200,
            ),
          ],
        ),
      );

      final result = await repository.getPackages();

      final packages = (result as Success<List<WalletPackage>>).data;
      expect(packages, hasLength(1));
      // Regression: the sheet's firstWhere(orElse:) crashed because the list
      // reified type was List<WalletPackageModel> instead of the declared
      // List<WalletPackage>.
      expect(packages.first, isNot(isA<WalletPackageModel>()));
      expect(packages.first, isA<WalletPackage>());
      expect(packages.first.name, 'Starter');
      expect(packages.first.loyaltyPoints, 200);
    });
  });

  group('PaymentMethodsRepositoryImpl.getPaymentMethods', () {
    test('returns plain entity instances, not models', () async {
      final repository = PaymentMethodsRepositoryImpl(
        _StubPaymentMethodsDataSource(
          methods: [
            const PaymentMethodModel(
              id: 'card-1',
              lastFour: '4242',
              expiryMonth: 12,
              expiryYear: 2027,
              brand: 'visa',
              isDefault: true,
            ),
          ],
        ),
      );

      final result = await repository.getPaymentMethods();

      final methods = (result as Success<List<PaymentMethod>>).data;
      expect(methods, hasLength(1));
      expect(methods.first, isNot(isA<PaymentMethodModel>()));
      expect(methods.first, isA<PaymentMethod>());
      expect(methods.first.isDefault, isTrue);
      expect(methods.first.lastFour, '4242');
    });
  });
}

class _StubWalletDataSource implements WalletDataSource {
  _StubWalletDataSource({this.packages = const []});

  final List<WalletPackageModel> packages;

  @override
  Future<List<WalletPackageModel>> getPackages() async => packages;

  @override
  Future<double> getBalance() => throw UnimplementedError();

  @override
  Future<List<WalletTransactionModel>> getTransactions() =>
      throw UnimplementedError();

  @override
  Future<void> updateWalletPhone(String phone) => throw UnimplementedError();

  @override
  Future<double?> buyPackage(String packageId) => throw UnimplementedError();
}

class _StubPaymentMethodsDataSource implements PaymentMethodsDataSource {
  _StubPaymentMethodsDataSource({this.methods = const []});

  final List<PaymentMethodModel> methods;

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async => methods;

  @override
  Future<void> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  }) => throw UnimplementedError();

  @override
  Future<void> deleteCard(String cardId) => throw UnimplementedError();
}
