import '../../domain/entities/payment_preferences.dart';

sealed class PaymentPreferencesState {
  const PaymentPreferencesState();
}

final class PaymentPreferencesLoading extends PaymentPreferencesState {
  const PaymentPreferencesLoading();
}

final class PaymentPreferencesLoaded extends PaymentPreferencesState {
  final PaymentPreferences preferences;

  const PaymentPreferencesLoaded(this.preferences);
}

final class PaymentPreferencesError extends PaymentPreferencesState {
  final String failureCode;

  const PaymentPreferencesError(this.failureCode);
}
