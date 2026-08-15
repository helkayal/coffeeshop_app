import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../domain/entities/user_profile.dart';
import '../models/loyalty_history_model.dart';
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

  @override
  Future<List<LoyaltyHistoryModel>> getLoyaltyHistory() async {
    final data = await _api.get(ApiConstants.loyaltyHistory);
    return (data as List<dynamic>)
        .map(
          (item) => LoyaltyHistoryModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<String?> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _api.post(
      ApiConstants.profileAvatar,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    if (res is Map<String, dynamic>) {
      final data = res['data'] as Map<String, dynamic>?;
      if (data != null && data['avatar_url'] is String) {
        return data['avatar_url'] as String;
      }
    }
    return null;
  }

  @override
  Future<void> changeEmail(String newEmail, String password) async {
    await _api.post(
      ApiConstants.profileChangeEmail,
      data: {'new_email': newEmail, 'password': password},
    );
  }
}
