import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';

abstract class ProfileDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile(UserProfile profile);
  Future<double> getLoyaltyPoints();
  Future<List<Map<String, dynamic>>> getLoyaltyHistory();
  Future<String?> uploadAvatar(String filePath);
  Future<void> changeEmail(String newEmail, String password);
}
