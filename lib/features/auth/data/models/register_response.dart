import 'user_model.dart';

/// Response shape returned by `POST /auth/register` after the backend update.
///
/// ```json
/// {
///   "success": true,
///   "data": {
///     "user": { ...profile fields... },
///     "tokens": { "access": "...", "refresh": "..." },
///     "verification_token": "..."
///   }
/// }
/// ```
class RegisterResponse {
  final UserModel user;
  final String accessToken;
  final String? refreshToken;
  final String? verificationToken;

  const RegisterResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.verificationToken,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    // Backend wraps everything in a `data` key.
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    final userJson = (data['user'] as Map<String, dynamic>?) ?? data;
    final tokens = data['tokens'] as Map<String, dynamic>?;

    return RegisterResponse(
      user: UserModel.fromJson(userJson),
      accessToken: (tokens?['access'] as String?) ?? '',
      refreshToken: tokens?['refresh'] as String?,
      verificationToken: data['verification_token'] as String?,
    );
  }
}
