import '../../../../core/helpers/result.dart';

abstract class PaymentMethodsRepository {
  Future<Result<List<Map<String, dynamic>>>> getPaymentMethods();
  Future<Result<void>> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  });
  Future<Result<void>> deleteCard(String cardId);
}
