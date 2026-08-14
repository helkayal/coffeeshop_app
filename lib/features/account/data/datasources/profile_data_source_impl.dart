import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';
import 'profile_data_source.dart';

class ProfileDataSourceImpl implements ProfileDataSource {
  final ApiService _api;

  ProfileDataSourceImpl(this._api);

  @override
  Future<UserProfileModel> getProfile() async {
    final data = await _api.get(ApiConstants.profile);
    return UserProfileModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfile profile) async {
    final updateData = <String, dynamic>{
      'first_name': profile.firstName,
      'last_name': profile.lastName,
    };
    if (profile.gender != null) {
      updateData['gender'] = profile.gender;
    }
    if (profile.state != null) {
      updateData['state'] = profile.state;
    }
    if (profile.city != null) {
      updateData['city'] = profile.city;
    }
    if (profile.dateOfBirth != null) {
      updateData['date_of_birth'] = profile.dateOfBirth;
    }

    final data = await _api.patch(ApiConstants.profileUpdate, data: updateData);
    return UserProfileModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<double> getLoyaltyPoints() async {
    final data = await _api.get(ApiConstants.loyalty);
    final loyaltyData = data as Map<String, dynamic>;
    return (loyaltyData['balance'] as num?)?.toDouble() ?? 0.0;
  }

  // // --- Mock data (commented out) ---
  // UserProfileModel _mockProfile() { ... }
}
