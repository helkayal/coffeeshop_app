import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<LoginResponse> login(String email, String password) async {
    // if (AppConfig.useMockData) return _mockLogin(email, password);
    final data = await _apiService.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return LoginResponse.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    String? state,
    String? city,
    DateTime? dateOfBirth,
  }) async {
    final data = await _apiService.post(
      ApiConstants.register,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'gender': gender,
        'state': state,
        'city': city,
        if (dateOfBirth != null)
          'date_of_birth': '${dateOfBirth.year}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}',
      },
    );
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> getProfile() async {
    final data = await _apiService.get(ApiConstants.profile);
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    await _apiService.post(
      ApiConstants.profileAvatar,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final data = await _apiService.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );
    return data as Map<String, dynamic>;
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await _apiService.post(
      ApiConstants.resetPassword,
      data: {'token': token, 'new_password': newPassword},
    );
  }

  @override
  Future<LoginResponse> socialLogin({
    required String provider,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    final data = await _apiService.post(
      ApiConstants.socialLogin,
      data: {
        'provider': provider,
        'email': email,
        'first_name': ?firstName,
        'last_name': ?lastName,
      },
    );
    return LoginResponse.fromJson(data as Map<String, dynamic>);
  }

  // // --- Mock implementations (commented out) ---
  // Future<LoginResponse> _mockLogin(String email, String password) async { ... }
  // Future<UserModel> _mockRegister(...) async { ... }
}
