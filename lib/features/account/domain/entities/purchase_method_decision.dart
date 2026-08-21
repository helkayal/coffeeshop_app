import 'payment_method.dart';

/// Outcome of [DecidePurchaseMethodUseCase] — the payment path a purchase
/// should take given saved preferences and available cards.
sealed class PurchaseMethodDecision {
  const PurchaseMethodDecision();
}

/// Pay via the mobile wallet number.
final class UseWalletDecision extends PurchaseMethodDecision {
  final String walletPhone;
  const UseWalletDecision(this.walletPhone);
}

/// Pay via Apple Pay.
final class UseApplePayDecision extends PurchaseMethodDecision {
  const UseApplePayDecision();
}

/// Pay with a saved card (requires CVC confirmation).
final class UseCardDecision extends PurchaseMethodDecision {
  final PaymentMethod card;
  const UseCardDecision(this.card);
}

/// No usable payment method exists.
final class NoPaymentMethodDecision extends PurchaseMethodDecision {
  const NoPaymentMethodDecision();
}
