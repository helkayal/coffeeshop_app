import '../../../../core/helpers/result.dart';
import '../entities/payment_preferences.dart';
import '../repositories/payment_preferences_repository.dart';

class GetPaymentPreferencesUseCase {
  final PaymentPreferencesRepository _repository;

  const GetPaymentPreferencesUseCase(this._repository);

  Future<Result<PaymentPreferences>> call() => _repository.getPreferences();
}

class SetDefaultPaymentMethodUseCase {
  final PaymentPreferencesRepository _repository;

  const SetDefaultPaymentMethodUseCase(this._repository);

  Future<Result<void>> call(String method) =>
      _repository.setDefaultMethod(method);
}

class SetWalletPhoneUseCase {
  final PaymentPreferencesRepository _repository;

  const SetWalletPhoneUseCase(this._repository);

  Future<Result<void>> call(String phone) => _repository.setWalletPhone(phone);
}
