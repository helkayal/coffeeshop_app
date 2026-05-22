import '../../../../core/helpers/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCachedUserUseCase {
  final AuthRepository _repository;

  const GetCachedUserUseCase(this._repository);

  Future<Result<User?>> call() => _repository.getCachedUser();
}
