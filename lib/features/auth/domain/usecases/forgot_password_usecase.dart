import '../../../../core/helpers/result.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;
  const ForgotPasswordUseCase(this._repository);
  Future<Result<Map<String, dynamic>>> call(String email) =>
      _repository.forgotPassword(email);
}
