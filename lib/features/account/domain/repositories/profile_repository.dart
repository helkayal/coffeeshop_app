import '../../../../core/helpers/result.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Result<UserProfile>> getProfile();
  Future<Result<UserProfile>> updateProfile(UserProfile profile);
  Future<Result<double>> getLoyaltyPoints();
}
