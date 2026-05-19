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
  });
  Future<Result<void>> logout();
  Future<Result<User?>> getCachedUser();
}
