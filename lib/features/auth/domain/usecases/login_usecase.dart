import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<Result<User>> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return const Error(ValidationFailure('Email and password cannot be empty.'));
    }
    return await repository.login(email, password);
  }
}
