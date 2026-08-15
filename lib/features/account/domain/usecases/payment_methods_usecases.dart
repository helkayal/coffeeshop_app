import '../../../../core/helpers/result.dart';
import '../entities/payment_method.dart';
import '../repositories/payment_methods_repository.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodsRepository _repository;
  const GetPaymentMethodsUseCase(this._repository);
  Future<Result<List<PaymentMethod>>> call() => _repository.getPaymentMethods();
}

class AddCardUseCase {
  final PaymentMethodsRepository _repository;
  const AddCardUseCase(this._repository);
  Future<Result<void>> call({
    required String number,
    required String expiry,
    required String cvv,
    required String name,
  }) =>
      _repository.addCard(number: number, expiry: expiry, cvv: cvv, name: name);
}

class DeleteCardUseCase {
  final PaymentMethodsRepository _repository;
  const DeleteCardUseCase(this._repository);
  Future<Result<void>> call(String cardId) => _repository.deleteCard(cardId);
}
