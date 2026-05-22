import '../models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String email, String password);
  Future<LoginResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    String? state,
    String? city,
  });
}
