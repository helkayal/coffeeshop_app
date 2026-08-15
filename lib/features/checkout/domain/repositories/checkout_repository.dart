import '../../../../core/helpers/result.dart';
import '../entities/checkout_item.dart';

abstract interface class CheckoutRepository {
  Future<Result<String>> createOrder(List<CheckoutItem> items);

  Future<Result<void>> payForOrder(String orderId, String paymentMethod);
}
