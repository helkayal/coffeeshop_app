import '../entities/payment_method.dart';
import '../entities/payment_preferences.dart';
import '../entities/purchase_method_decision.dart';

/// Decides which payment path a package purchase should take:
/// mobile wallet, Apple Pay, a saved card, or none available.
class DecidePurchaseMethodUseCase {
  const DecidePurchaseMethodUseCase();

  PurchaseMethodDecision call({
    required PaymentPreferences? preferences,
    required List<PaymentMethod> cards,
  }) {
    final walletPhone = preferences?.walletPhone;
    final hasWalletPhone =
        walletPhone != null && walletPhone.trim().isNotEmpty;
    final defaultMethod = preferences?.defaultMethod;

    if (defaultMethod == 'wallet' || (cards.isEmpty && hasWalletPhone)) {
      return UseWalletDecision(walletPhone?.trim() ?? '');
    }
    if (defaultMethod == 'applepay') {
      return const UseApplePayDecision();
    }
    if (cards.isNotEmpty) {
      // An explicit saved card id takes priority over the isDefault flag;
      // fall back to the flagged card, then to the first card.
      final defaultCard = cards.firstWhere(
        (card) => card.id == defaultMethod,
        orElse: () => cards.firstWhere(
          (card) => card.isDefault,
          orElse: () => cards.first,
        ),
      );
      return UseCardDecision(defaultCard);
    }
    if (hasWalletPhone) {
      return UseWalletDecision(walletPhone.trim());
    }
    return const NoPaymentMethodDecision();
  }
}
