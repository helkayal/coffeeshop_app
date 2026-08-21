import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/account/domain/entities/payment_preferences.dart';
import 'package:coffeeshop_app/features/account/domain/repositories/payment_preferences_repository.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/payment_preferences_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetPaymentPreferencesUseCase', () {
    test('returns the preferences from the repository', () async {
      final repository = _FakePaymentPreferencesRepository()
        ..preferences = const PaymentPreferences(
          defaultMethod: 'wallet',
          walletPhone: '050123',
        );

      final result = await GetPaymentPreferencesUseCase(repository)();

      final preferences = (result as Success<PaymentPreferences>).data;
      expect(preferences.defaultMethod, 'wallet');
      expect(preferences.walletPhone, '050123');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakePaymentPreferencesRepository()
        ..failure = const CacheFailure('errors.payment_preferences_load_failed');

      final result = await GetPaymentPreferencesUseCase(repository)();

      expect(result, isA<Error<PaymentPreferences>>());
      expect((result as Error<PaymentPreferences>).failure.message,
          'errors.payment_preferences_load_failed');
    });
  });

  group('SetDefaultPaymentMethodUseCase', () {
    test('forwards the method to the repository', () async {
      final repository = _FakePaymentPreferencesRepository();
      final useCase = SetDefaultPaymentMethodUseCase(repository);

      final result = await useCase('card-1');

      expect(result, isA<Success<void>>());
      expect(repository.lastMethod, 'card-1');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakePaymentPreferencesRepository()
        ..failure = const CacheFailure('errors.payment_method_save_failed');

      final result = await SetDefaultPaymentMethodUseCase(repository)('card-1');

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure.message,
          'errors.payment_method_save_failed');
    });
  });

  group('SetWalletPhoneUseCase', () {
    test('forwards the phone to the repository', () async {
      final repository = _FakePaymentPreferencesRepository();
      final useCase = SetWalletPhoneUseCase(repository);

      final result = await useCase('050123456');

      expect(result, isA<Success<void>>());
      expect(repository.lastPhone, '050123456');
    });

    test('propagates repository failures unchanged', () async {
      final repository = _FakePaymentPreferencesRepository()
        ..failure = const CacheFailure('errors.wallet_phone_save_failed');

      final result = await SetWalletPhoneUseCase(repository)('050123456');

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure.message,
          'errors.wallet_phone_save_failed');
    });
  });
}

class _FakePaymentPreferencesRepository
    implements PaymentPreferencesRepository {
  PaymentPreferences preferences = const PaymentPreferences();
  Failure? failure;
  String? lastMethod;
  String? lastPhone;

  @override
  Future<Result<PaymentPreferences>> getPreferences() async {
    final failure = this.failure;
    return failure == null ? Success(preferences) : Error(failure);
  }

  @override
  Future<Result<void>> setDefaultMethod(String method) async {
    lastMethod = method;
    final failure = this.failure;
    return failure == null ? const Success(null) : Error(failure);
  }

  @override
  Future<Result<void>> setWalletPhone(String phone) async {
    lastPhone = phone;
    final failure = this.failure;
    return failure == null ? const Success(null) : Error(failure);
  }
}
