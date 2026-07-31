import '../../../../core/helpers/result.dart';
import '../repositories/auth_repository.dart';

class ResendVerificationUseCase {
  final AuthRepository _repository;

  const ResendVerificationUseCase(this._repository);

  Future<Result<void>> call(String email) =>
      _repository.resendVerification(email);
}
