import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/payment_preferences.dart';
import '../../domain/repositories/payment_preferences_repository.dart';

class PaymentPreferencesRepositoryImpl implements PaymentPreferencesRepository {
  final LocalStorageService _storage;

  const PaymentPreferencesRepositoryImpl(this._storage);

  @override
  Future<Result<PaymentPreferences>> getPreferences() async {
    try {
      return Success(
        PaymentPreferences(
          defaultMethod: _storage.getDefaultPaymentMethod(),
          walletPhone: _storage.getWalletPhone(),
        ),
      );
    } catch (_) {
      return const Error(CacheFailure('payment_preferences_load_failed'));
    }
  }

  @override
  Future<Result<void>> setDefaultMethod(String method) async {
    try {
      await _storage.setDefaultPaymentMethod(method);
      return const Success(null);
    } catch (_) {
      return const Error(CacheFailure('payment_method_save_failed'));
    }
  }

  @override
  Future<Result<void>> setWalletPhone(String phone) async {
    try {
      await _storage.setWalletPhone(phone);
      return const Success(null);
    } catch (_) {
      return const Error(CacheFailure('wallet_phone_save_failed'));
    }
  }
}
