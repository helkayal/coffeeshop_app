import '../../../../core/helpers/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  // Presence validation is handled by the UI. The use case delegates directly
  // to the repository. Business-rule validation (email format, etc.)
  // should be added here when needed.
  Future<Result<User>> call(String email, String password) =>
      repository.login(email, password);
}
