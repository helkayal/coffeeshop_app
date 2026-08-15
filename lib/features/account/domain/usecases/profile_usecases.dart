import '../../../../core/helpers/result.dart';
import '../entities/loyalty_history_entry.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;
  const GetProfileUseCase(this._repository);
  Future<Result<UserProfile>> call() => _repository.getProfile();
}

class UpdateProfileUseCase {
  final ProfileRepository _repository;
  const UpdateProfileUseCase(this._repository);
  Future<Result<UserProfile>> call(UserProfile profile) =>
      _repository.updateProfile(profile);
}

class GetLoyaltyPointsUseCase {
  final ProfileRepository _repository;
  const GetLoyaltyPointsUseCase(this._repository);
  Future<Result<double>> call() => _repository.getLoyaltyPoints();
}

class GetLoyaltyHistoryUseCase {
  final ProfileRepository _repository;
  const GetLoyaltyHistoryUseCase(this._repository);
  Future<Result<List<LoyaltyHistoryEntry>>> call() =>
      _repository.getLoyaltyHistory();
}

class UploadAvatarUseCase {
  final ProfileRepository _repository;
  const UploadAvatarUseCase(this._repository);
  Future<Result<String?>> call(String filePath) =>
      _repository.uploadAvatar(filePath);
}

class ChangeEmailUseCase {
  final ProfileRepository _repository;
  const ChangeEmailUseCase(this._repository);
  Future<Result<void>> call(String newEmail, String password) =>
      _repository.changeEmail(newEmail, password);
}
