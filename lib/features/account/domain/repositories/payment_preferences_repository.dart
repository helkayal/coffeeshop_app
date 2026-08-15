import '../../../../core/helpers/result.dart';
import '../entities/payment_preferences.dart';

abstract interface class PaymentPreferencesRepository {
  Future<Result<PaymentPreferences>> getPreferences();

  Future<Result<void>> setDefaultMethod(String method);

  Future<Result<void>> setWalletPhone(String phone);
}
