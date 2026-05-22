import 'user_model.dart';

/// Wraps the response from the auth endpoints to carry both the user
/// payload and the server-issued JWT token in one object.
class LoginResponse {
  final UserModel user;
  final String token;

  const LoginResponse({required this.user, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}
