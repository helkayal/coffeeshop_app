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
  final List<Map<String, dynamic>> cards;
  const PaymentMethodsLoaded(this.cards);
}

final class PaymentMethodsActionInProgress extends PaymentMethodsState {
  final List<Map<String, dynamic>> cards;
  const PaymentMethodsActionInProgress(this.cards);
}

final class PaymentMethodsError extends PaymentMethodsState {
  final String message;
  const PaymentMethodsError(this.message);
}
