import 'package:coffeeshop_app/features/account/domain/entities/payment_method.dart';
import 'package:coffeeshop_app/features/account/domain/entities/payment_preferences.dart';
import 'package:coffeeshop_app/features/account/domain/entities/purchase_method_decision.dart';
import 'package:coffeeshop_app/features/account/domain/usecases/decide_purchase_method.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const useCase = DecidePurchaseMethodUseCase();

  group('DecidePurchaseMethodUseCase', () {
    test('uses the wallet when defaultMethod is wallet', () {
      final decision = useCase(
        preferences: const PaymentPreferences(
          defaultMethod: 'wallet',
          walletPhone: ' 050 123 456 ',
        ),
        cards: _cards(),
      );

      expect(decision, isA<UseWalletDecision>());
      expect((decision as UseWalletDecision).walletPhone, '050 123 456');
    });

    test('uses wallet with an empty phone when none is stored', () {
      final decision = useCase(
        preferences: const PaymentPreferences(defaultMethod: 'wallet'),
        cards: _cards(),
      );

      expect((decision as UseWalletDecision).walletPhone, '');
    });

    test('uses the wallet phone when no cards exist', () {
      final decision = useCase(
        preferences: const PaymentPreferences(walletPhone: ' 050111  '),
        cards: const [],
      );

      expect(decision, isA<UseWalletDecision>());
      expect((decision as UseWalletDecision).walletPhone, '050111');
    });

    test('uses Apple Pay when defaultMethod is applepay', () {
      final decision = useCase(
        preferences: const PaymentPreferences(defaultMethod: 'applepay'),
        cards: _cards(),
      );

      expect(decision, isA<UseApplePayDecision>());
    });

    test('uses Apple Pay even with no cards and no wallet phone', () {
      final decision = useCase(
        preferences: const PaymentPreferences(defaultMethod: 'applepay'),
        cards: const [],
      );

      expect(decision, isA<UseApplePayDecision>());
    });

    test('picks the card whose id matches defaultMethod', () {
      final decision = useCase(
        preferences: const PaymentPreferences(defaultMethod: 'card-2'),
        cards: _cards(),
      );

      expect((decision as UseCardDecision).card.id, 'card-2');
    });

    test('falls back to the default card when defaultMethod matches nothing',
        () {
      final decision = useCase(
        preferences: const PaymentPreferences(defaultMethod: 'card-9'),
        cards: _cards(),
      );

      expect((decision as UseCardDecision).card.id, 'card-1');
    });

    test('picks the first card when neither id nor isDefault matches', () {
      final decision = useCase(
        preferences: null,
        cards: [
          _card(id: 'card-a', isDefault: false),
          _card(id: 'card-b', isDefault: false),
        ],
      );

      expect((decision as UseCardDecision).card.id, 'card-a');
    });

    test('falls back to the wallet phone when cards are empty', () {
      final decision = useCase(
        preferences: const PaymentPreferences(walletPhone: '050123456'),
        cards: const [],
      );

      expect(decision, isA<UseWalletDecision>());
      expect((decision as UseWalletDecision).walletPhone, '050123456');
    });

    test('reports no payment method when nothing is available', () {
      final decision = useCase(preferences: null, cards: const []);

      expect(decision, isA<NoPaymentMethodDecision>());
    });

    test('reports no payment method when the wallet phone is blank', () {
      final decision = useCase(
        preferences: const PaymentPreferences(walletPhone: '   '),
        cards: const [],
      );

      expect(decision, isA<NoPaymentMethodDecision>());
    });
  });
}

PaymentMethod _card({required String id, required bool isDefault}) =>
    PaymentMethod(
      id: id,
      lastFour: '4242',
      expiryMonth: 12,
      expiryYear: 2027,
      brand: 'visa',
      isDefault: isDefault,
    );

List<PaymentMethod> _cards() => [
  _card(id: 'card-1', isDefault: true),
  _card(id: 'card-2', isDefault: false),
];
