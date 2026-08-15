import '../../../../core/helpers/result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String email, String password);
  Future<Result<User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    String? state,
    String? city,
    DateTime? dateOfBirth,
  });
  Future<Result<void>> logout();
  Future<Result<User?>> getCachedUser();
  Future<Result<Map<String, dynamic>>> forgotPassword(String email);
  Future<Result<void>> resetPassword(String token, String newPassword);
  Future<Result<User>> socialLogin({
    required String provider,
    required String email,
    String? firstName,
    String? lastName,
  });
  Future<Result<User>> refreshSession();
  Future<Result<void>> verifyEmail(String token);
  Future<Result<void>> resendVerification(String email);
  Future<Result<void>> savePendingAvatar(String path);
}
