import '../../../../config/app_config.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';
import 'profile_data_source.dart';

class ProfileDataSourceImpl implements ProfileDataSource {
  final ApiService _api;
  final LocalStorageService _localStorage;

  ProfileDataSourceImpl(this._api, this._localStorage);

  @override
  Future<UserProfileModel> getProfile() async {
    if (AppConfig.useMockData) return _mockProfile();
    final response = await _api.get(ApiConstants.profile);
    return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserProfileModel> updateProfile(UserProfile profile) async {
    if (AppConfig.useMockData) {
      return UserProfileModel(
        id: profile.id,
        firstName: profile.firstName,
        lastName: profile.lastName,
        email: profile.email,
        gender: profile.gender,
        state: profile.state,
        city: profile.city,
        phone: profile.phone,
        profilePictureUrl: profile.profilePictureUrl,
      );
    }
    final response = await _api.put(
      ApiConstants.profile,
      data: UserProfileModel(
        id: profile.id,
        firstName: profile.firstName,
        lastName: profile.lastName,
        email: profile.email,
        gender: profile.gender,
        state: profile.state,
        city: profile.city,
        phone: profile.phone,
        profilePictureUrl: profile.profilePictureUrl,
      ).toJson(),
    );
    return UserProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<double> getLoyaltyPoints() async {
    if (AppConfig.useMockData) return 360.0;
    final response = await _api.get(ApiConstants.loyalty);
    final data = response.data as Map<String, dynamic>;
    return (data['points'] as num).toDouble();
  }

  UserProfileModel _mockProfile() {
    // Build from cached user if available, else use placeholder.
    final cached = _localStorage.getCurrentUser();
    if (cached != null) {
      return UserProfileModel.fromJson(cached);
    }
    return const UserProfileModel(
      id: '1',
      firstName: 'Test',
      lastName: 'User',
      email: 'test@test.com',
      gender: 'Male',
      state: 'Cairo',
      city: 'New Cairo',
    );
  }
}
