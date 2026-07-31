import '../../../../core/helpers/result.dart';
import '../repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository _repository;

  const VerifyEmailUseCase(this._repository);

  Future<Result<void>> call(String token) => _repository.verifyEmail(token);
}
