abstract class PaymentMethodsDataSource {
  Future<List<Map<String, dynamic>>> getPaymentMethods();
  Future<void> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  });
  Future<void> deleteCard(String cardId);
}
