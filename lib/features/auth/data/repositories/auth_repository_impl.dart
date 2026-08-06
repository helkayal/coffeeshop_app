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
      final response = await _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        gender: gender,
        state: state,
        city: city,
        dateOfBirth: dateOfBirth,
      );

      // Persist tokens returned by registration so the session is warm.
      await _localStorage.setAuthToken(response.accessToken);
      if (response.refreshToken != null) {
        await _localStorage.setRefreshToken(response.refreshToken!);
      }
      await _localStorage.cacheUser(response.user.toJson());

      // Upload avatar immediately using the registration access token.
      // We pass the token explicitly because the interceptor picks up tokens
      // from storage only after a full round-trip — using the temp token here
      // avoids the 401 that was caused by the lag.
      final pendingAvatar = _localStorage.getPendingAvatarPath();
      if (pendingAvatar != null && response.accessToken.isNotEmpty) {
        _localStorage.clearPendingAvatarPath();
        try {
          await _remoteDataSource.uploadAvatarWithToken(
            pendingAvatar,
            response.accessToken,
          );
        } catch (_) {
          // Non-fatal — avatar can be set later from profile screen.
        }
      }

      return Success(response.user);
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

  /// Proactively uses the stored refresh token to obtain a new access token.
  /// Called at app startup by [SplashScreen]. Returns [AuthSessionExpired]
  /// failure when the refresh token is missing or rejected by the server.
  @override
  Future<Result<User>> refreshSession() async {
    final storedRefresh = _localStorage.getRefreshToken();
    if (storedRefresh == null) {
      return const Error(ServerFailure('No refresh token'));
    }
    try {
      final response = await _remoteDataSource.refreshToken(storedRefresh);
      await _localStorage.setAuthToken(response.accessToken);
      await _localStorage.setRefreshToken(response.refreshToken);
      final user = await _remoteDataSource.getProfile();
      await _localStorage.cacheUser(user.toJson());
      return Success(user);
    } on ServerException catch (e) {
      await _localStorage.clearSession();
      return Error(ServerFailure(e.message ?? 'Session expired'));
    } on ConnectionException catch (e) {
      return Error(ConnectionFailure(e.message));
    } catch (_) {
      await _localStorage.clearSession();
      return const Error(ServerFailure('Session expired'));
    }
  }

  @override
  Future<Result<void>> verifyEmail(String token) async {
    try {
      await _remoteDataSource.verifyEmail(token);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Verification failed'));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Result<void>> resendVerification(String email) async {
    try {
      await _remoteDataSource.resendVerification(email);
      return const Success(null);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Failed to resend verification'));
    } catch (_) {
      return const Error(ServerFailure('An unexpected error occurred'));
    }
  }
}
