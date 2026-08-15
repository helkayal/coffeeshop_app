import '../../domain/entities/user_profile.dart';
import '../models/loyalty_history_model.dart';
import '../models/user_profile_model.dart';

abstract class ProfileDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile(UserProfile profile);
  Future<double> getLoyaltyPoints();
  Future<List<LoyaltyHistoryModel>> getLoyaltyHistory();
  Future<String?> uploadAvatar(String filePath);
  Future<void> changeEmail(String newEmail, String password);
}
