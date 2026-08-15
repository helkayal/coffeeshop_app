class LoginResponse {
  final String accessToken;
  final String refreshToken;

  const LoginResponse({required this.accessToken, required this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access'] as String,
      // /auth/refresh may return only a new access token; keep the old refresh
      // when the backend uses ROTATE_REFRESH_TOKENS=False.
      refreshToken: (json['refresh'] as String?) ?? (json['access'] as String),
    );
  }
}
