import '../../../../config/app_config.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<LoginResponse> login(String email, String password) async {
    if (AppConfig.useMockData) return _mockLogin(email, password);
    final response = await _apiService.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<LoginResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    String? state,
    String? city,
  }) async {
    if (AppConfig.useMockData) {
      return _mockRegister(firstName, lastName, email);
    }
    final response = await _apiService.post(
      ApiConstants.register,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'gender': gender,
        'state': state,
        'city': city,
      },
    );
    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<LoginResponse> _mockLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@test.com' && password == 'password') {
      return LoginResponse(
        user: const UserModel(
          id: '1',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@test.com',
        ),
        token: 'mock-jwt-token',
      );
    }
    throw const ServerException('Invalid email or password');
  }

  Future<LoginResponse> _mockRegister(
    String firstName,
    String lastName,
    String email,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return LoginResponse(
      user: UserModel(
        id: '2',
        firstName: firstName,
        lastName: lastName,
        email: email,
      ),
      token: 'mock-jwt-token',
    );
  }
}
