import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final LocalStorageService _localStorage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required LocalStorageService localStorage,
  })  : _remoteDataSource = remoteDataSource,
        _localStorage = localStorage;

  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);
      await _localStorage.setAuthToken(response.token);
      await _localStorage.setCurrentUser(response.user.toJson());
      return Success(response.user);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return const Error(ServerFailure('Unexpected Error'));
    }
  }

  @override
  Future<Result<User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    String? state,
    String? city,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        gender: gender,
        state: state,
        city: city,
      );
      await _localStorage.setAuthToken(response.token);
      await _localStorage.setCurrentUser(response.user.toJson());
      return Success(response.user);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return const Error(ServerFailure('Unexpected Error'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _localStorage.clearAuthToken();
      await _localStorage.clearCurrentUser();
      if (kDebugMode) debugPrint('[Auth] Session cleared');
      return const Success(null);
    } catch (e) {
      return const Error(CacheFailure('Failed to clear session'));
    }
  }

  @override
  Future<Result<User?>> getCachedUser() async {
    try {
      final userJson = _localStorage.getCurrentUser();
      if (userJson == null) return const Success(null);
      return Success(UserModel.fromJson(userJson));
    } catch (e) {
      return const Success(null);
    }
  }
}
