import '../../../../core/helpers/result.dart';
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
