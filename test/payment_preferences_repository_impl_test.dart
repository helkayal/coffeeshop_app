import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/core/services/local_storage_service.dart';
import 'package:coffeeshop_app/features/account/data/repositories/payment_preferences_repository_impl.dart';
import 'package:coffeeshop_app/features/account/domain/entities/payment_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentPreferencesRepositoryImpl.getPreferences', () {
    test('returns the payment preferences stored locally', () async {
      final repository = PaymentPreferencesRepositoryImpl(
        _FakeLocalStorageService(
          defaultMethod: 'card-1',
          walletPhone: '050123',
        ),
      );

      final result = await repository.getPreferences();

      final preferences = (result as Success<PaymentPreferences>).data;
      expect(preferences.defaultMethod, 'card-1');
      expect(preferences.walletPhone, '050123');
    });

    test('maps a storage error to the load failure key', () async {
      final repository = PaymentPreferencesRepositoryImpl(
        _FakeLocalStorageService()..throwOnRead = true,
      );

      final result = await repository.getPreferences();

      expect(
        (result as Error<PaymentPreferences>).failure,
        isA<CacheFailure>().having(
          (f) => f.message,
          'message',
          'errors.payment_preferences_load_failed',
        ),
      );
    });
  });

  group('PaymentPreferencesRepositoryImpl.setDefaultMethod', () {
    test('persists the default payment method', () async {
      final storage = _FakeLocalStorageService();
      final repository = PaymentPreferencesRepositoryImpl(storage);

      final result = await repository.setDefaultMethod('applepay');

      expect(result, isA<Success<void>>());
      expect(storage.defaultMethod, 'applepay');
    });

    test('maps a storage error to the save failure key', () async {
      final repository = PaymentPreferencesRepositoryImpl(
        _FakeLocalStorageService()..throwOnWrite = true,
      );

      final result = await repository.setDefaultMethod('applepay');

      expect(
        (result as Error<void>).failure,
        isA<CacheFailure>().having(
          (f) => f.message,
          'message',
          'errors.payment_method_save_failed',
        ),
      );
    });
  });

  group('PaymentPreferencesRepositoryImpl.setWalletPhone', () {
    test('persists the wallet phone', () async {
      final storage = _FakeLocalStorageService();
      final repository = PaymentPreferencesRepositoryImpl(storage);

      final result = await repository.setWalletPhone('050123456');

      expect(result, isA<Success<void>>());
      expect(storage.walletPhone, '050123456');
    });

    test('maps a storage error to the save failure key', () async {
      final repository = PaymentPreferencesRepositoryImpl(
        _FakeLocalStorageService()..throwOnWrite = true,
      );

      final result = await repository.setWalletPhone('050123456');

      expect(
        (result as Error<void>).failure,
        isA<CacheFailure>().having(
          (f) => f.message,
          'message',
          'errors.wallet_phone_save_failed',
        ),
      );
    });
  });
}

class _FakeLocalStorageService implements LocalStorageService {
  _FakeLocalStorageService({this.defaultMethod, this.walletPhone});

  String? defaultMethod;
  String? walletPhone;
  bool throwOnRead = false;
  bool throwOnWrite = false;

  @override
  String? getDefaultPaymentMethod() {
    if (throwOnRead) throw StateError('storage down');
    return defaultMethod;
  }

  @override
  String? getWalletPhone() {
    if (throwOnRead) throw StateError('storage down');
    return walletPhone;
  }

  @override
  Future<void> setDefaultPaymentMethod(String method) async {
    if (throwOnWrite) throw StateError('storage down');
    defaultMethod = method;
  }

  @override
  Future<void> setWalletPhone(String phone) async {
    if (throwOnWrite) throw StateError('storage down');
    walletPhone = phone;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
