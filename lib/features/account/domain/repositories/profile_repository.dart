import '../../../../core/helpers/result.dart';
import '../entities/loyalty_history_entry.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Result<UserProfile>> getProfile();
  Future<Result<UserProfile>> updateProfile(UserProfile profile);
  Future<Result<double>> getLoyaltyPoints();
  Future<Result<List<LoyaltyHistoryEntry>>> getLoyaltyHistory();
  Future<Result<String?>> uploadAvatar(String filePath);
  Future<Result<void>> changeEmail(String newEmail, String password);
}
