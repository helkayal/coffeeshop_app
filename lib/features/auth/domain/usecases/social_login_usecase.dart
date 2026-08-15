import '../../../../core/helpers/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SocialLoginUseCase {
  final AuthRepository _repository;
  const SocialLoginUseCase(this._repository);

  Future<Result<User>> call({
    required String provider,
    required String email,
    String? firstName,
    String? lastName,
  }) => _repository.socialLogin(
    provider: provider,
    email: email,
    firstName: firstName,
    lastName: lastName,
  );
}
