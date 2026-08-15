import '../../../../core/helpers/result.dart';
import '../entities/payment_method.dart';

abstract class PaymentMethodsRepository {
  Future<Result<List<PaymentMethod>>> getPaymentMethods();
  Future<Result<void>> addCard({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  });
  Future<Result<void>> deleteCard(String cardId);
}
