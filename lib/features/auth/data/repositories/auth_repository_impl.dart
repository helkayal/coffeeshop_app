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
      await _localStorage.setAuthToken(response.accessToken);
      await _localStorage.setRefreshToken(response.refreshToken);

      final user = await _remoteDataSource.getProfile();
      await _localStorage.cacheUser(user.toJson());

      // Upload pending avatar picked during registration (best-effort).
      final pendingAvatar = _localStorage.getPendingAvatarPath();
      if (pendingAvatar != null) {
        _localStorage.clearPendingAvatarPath();
        try {
          await _remoteDataSource.uploadAvatar(pendingAvatar);
        } catch (_) {
          // Non-fatal — avatar can be set later from profile screen.
        }
      }

      return Success(user);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Invalid email or password'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (e) {
      return const Error(ServerFailure('An unexpected error occurred'));
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
    DateTime? dateOfBirth,
  }) async {
    try {
      final user = await _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        gender: gender,
        state: state,
        city: city,
        dateOfBirth: dateOfBirth,
      );
      await _localStorage.cacheUser(user.toJson());

      // Upload pending avatar picked during registration (best-effort).
      final pendingAvatar = _localStorage.getPendingAvatarPath();
      if (pendingAvatar != null) {
        _localStorage.clearPendingAvatarPath();
        try {
          await _remoteDataSource.uploadAvatar(pendingAvatar);
        } catch (_) {
          // Non-fatal — avatar can be set later from profile screen.
        }
      }

      return Success(user);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Registration failed'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (e) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _localStorage.clearSession();
      if (kDebugMode) debugPrint('[Auth] Session cleared');
      return const Success(null);
    } catch (e) {
      return const Error(CacheFailure('Failed to clear session'));
    }
  }

  @override
  Future<Result<User?>> getCachedUser() async {
    try {
      final userJson = _localStorage.getCachedUser();
      if (userJson == null) return const Success(null);
      return Success(UserModel.fromJson(userJson));
    } catch (e) {
      return const Success(null);
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> forgotPassword(String email) async {
    try {
      final result = await _remoteDataSource.forgotPassword(email);
      return Success(result);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to send reset email'));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<void>> resetPassword(String token, String newPassword) async {
    try {
      await _remoteDataSource.resetPassword(token, newPassword);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to reset password'));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<User>> socialLogin({
    required String provider,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await _remoteDataSource.socialLogin(
        provider: provider,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
      await _localStorage.setAuthToken(response.accessToken);
      await _localStorage.setRefreshToken(response.refreshToken);
      final user = await _remoteDataSource.getProfile();
      await _localStorage.cacheUser(user.toJson());
      return Success(user);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Social login failed'));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }
}
