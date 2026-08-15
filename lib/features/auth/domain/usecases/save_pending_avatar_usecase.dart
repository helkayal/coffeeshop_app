import '../../../../core/helpers/result.dart';
import '../repositories/auth_repository.dart';

class SavePendingAvatarUseCase {
  final AuthRepository _repository;

  const SavePendingAvatarUseCase(this._repository);

  Future<Result<void>> call(String path) => _repository.savePendingAvatar(path);
}
