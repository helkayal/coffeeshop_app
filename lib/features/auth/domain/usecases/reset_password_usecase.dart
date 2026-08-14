import '../../../../core/helpers/result.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;
  const ResetPasswordUseCase(this._repository);
  Future<Result<void>> call(String token, String newPassword) =>
      _repository.resetPassword(token, newPassword);
}
