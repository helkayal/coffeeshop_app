import '../../domain/entities/payment_method.dart';

sealed class PaymentMethodsState {
  const PaymentMethodsState();
}

final class PaymentMethodsInitial extends PaymentMethodsState {
  const PaymentMethodsInitial();
}

final class PaymentMethodsLoading extends PaymentMethodsState {
  const PaymentMethodsLoading();
}

final class PaymentMethodsLoaded extends PaymentMethodsState {
  final List<PaymentMethod> cards;
  const PaymentMethodsLoaded(this.cards);
}

final class PaymentMethodsActionInProgress extends PaymentMethodsState {
  final List<PaymentMethod> cards;
  const PaymentMethodsActionInProgress(this.cards);
}

final class PaymentMethodsError extends PaymentMethodsState {
  final String message;
  const PaymentMethodsError(this.message);
}
