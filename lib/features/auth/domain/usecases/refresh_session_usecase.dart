import '../../../../core/helpers/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RefreshSessionUseCase {
  final AuthRepository _repository;

  const RefreshSessionUseCase(this._repository);

  Future<Result<User>> call() => _repository.refreshSession();
}
