import '../models/login_response.dart';
import '../models/register_response.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String email, String password);
  Future<RegisterResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    String? state,
    String? city,
    DateTime? dateOfBirth,
  });
  Future<UserModel> getProfile();
  Future<void> uploadAvatar(String filePath);

  /// Uploads an avatar using an explicitly provided [accessToken].
  /// Used immediately after registration before the token is stored in
  /// secure storage (the interceptor hasn't been updated yet at that point).
  Future<void> uploadAvatarWithToken(String filePath, String accessToken);

  Future<Map<String, dynamic>> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<LoginResponse> socialLogin({
    required String provider,
    required String email,
    String? firstName,
    String? lastName,
  });
  Future<LoginResponse> refreshToken(String refreshToken);
  Future<void> verifyEmail(String token);
  Future<void> resendVerification(String email);
}
