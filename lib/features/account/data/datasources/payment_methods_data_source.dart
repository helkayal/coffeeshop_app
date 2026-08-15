import '../models/payment_method_model.dart';

abstract class PaymentMethodsDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<void> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  });
  Future<void> deleteCard(String cardId);
}
