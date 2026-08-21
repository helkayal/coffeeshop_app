import 'package:coffeeshop_app/core/errors/exceptions.dart';
import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/core/security/credential_storage.dart';
import 'package:coffeeshop_app/core/services/local_storage_service.dart';
import 'package:coffeeshop_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:coffeeshop_app/features/auth/data/models/login_response.dart';
import 'package:coffeeshop_app/features/auth/data/models/register_response.dart';
import 'package:coffeeshop_app/features/auth/data/models/user_model.dart';
import 'package:coffeeshop_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coffeeshop_app/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

const _profileUser = UserModel(
  id: 'u1',
  firstName: 'Ana',
  lastName: 'S',
  email: 'ana@example.com',
  isVerified: true,
);

void main() {
  late _FakeAuthRemoteDataSource remote;
  late _FakeLocalStorage local;
  late _FakeCredentials credentials;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _FakeAuthRemoteDataSource();
    local = _FakeLocalStorage();
    credentials = _FakeCredentials();
    repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      localStorage: local,
      credentials: credentials,
    );
  });

  group('login', () {
    test('persists tokens and caches the profile user on success', () async {
      final result = await repository.login('ana@example.com', 'pw');

      expect(credentials.access, 'access-1');
      expect(credentials.refresh, 'refresh-1');
      expect(local.cachedUser, _profileUser.toJson());
      final user = (result as Success<User>).data;
      expect(user.id, 'u1');
      expect(user.email, 'ana@example.com');
    });

    test('uploads and clears a pending avatar after login', () async {
      local.pendingAvatarPath = '/tmp/pending.png';

      final result = await repository.login('ana@example.com', 'pw');

      expect(remote.uploadAvatarCalls, 1);
      expect(remote.lastUploadedPath, '/tmp/pending.png');
      expect(local.pendingAvatarPath, isNull);
      expect(result, isA<Success<User>>());
    });

    test('succeeds even when the pending avatar upload fails', () async {
      local.pendingAvatarPath = '/tmp/pending.png';
      remote.uploadAvatarError = const ServerException('upload_failed');

      final result = await repository.login('ana@example.com', 'pw');

      expect(local.pendingAvatarPath, isNull);
      expect(result, isA<Success<User>>());
    });

    test('maps a server exception to a ServerFailure with its message',
        () async {
      remote.loginError = const ServerException('wrong_credentials');

      final result = await repository.login('ana@example.com', 'pw');

      expect(
        (result as Error<User>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'wrong_credentials',
        ),
      );
    });

    test('falls back to invalid_credentials when the server sends no message',
        () async {
      remote.loginError = const ServerException();

      final result = await repository.login('ana@example.com', 'pw');

      expect(
        (result as Error<User>).failure.message,
        'errors.invalid_credentials',
      );
    });

    test('maps a connection exception to a ConnectionFailure', () async {
      remote.loginError = const ConnectionException('errors.network_error');

      final result = await repository.login('ana@example.com', 'pw');

      expect(
        (result as Error<User>).failure,
        isA<ConnectionFailure>().having(
          (f) => f.message,
          'message',
          'errors.network_error',
        ),
      );
    });

    test('maps unexpected errors to a generic ServerFailure', () async {
      remote.profileError = StateError('boom');

      final result = await repository.login('ana@example.com', 'pw');

      expect(
        (result as Error<User>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('register', () {
    Future<Result<User>> register() => repository.register(
      firstName: 'Ana',
      lastName: 'S',
      email: 'ana@example.com',
      password: 'pw',
      gender: 'female',
    );

    test('persists tokens and caches the user on success', () async {
      final result = await register();

      expect(credentials.access, 'access-1');
      expect(credentials.refresh, 'refresh-1');
      expect(local.cachedUser, _profileUser.toJson());
      expect((result as Success<User>).data.id, 'u1');
    });

    test('writes only the access token when no refresh token is returned',
        () async {
      remote.registerResponse = const RegisterResponse(
        user: _profileUser,
        accessToken: 'access-1',
      );

      await register();

      expect(credentials.access, 'access-1');
      expect(credentials.refresh, isNull);
      expect(credentials.refreshWrites, 0);
    });

    test('uploads a pending avatar with the registration access token',
        () async {
      local.pendingAvatarPath = '/tmp/pending.png';

      await register();

      expect(remote.uploadAvatarWithTokenCalls, 1);
      expect(remote.lastUploadedPath, '/tmp/pending.png');
      expect(remote.lastUploadToken, 'access-1');
      expect(local.pendingAvatarPath, isNull);
    });

    test('skips avatar upload when the registration access token is empty',
        () async {
      local.pendingAvatarPath = '/tmp/pending.png';
      remote.registerResponse = const RegisterResponse(
        user: _profileUser,
        accessToken: '',
      );

      await register();

      expect(remote.uploadAvatarWithTokenCalls, 0);
      expect(local.pendingAvatarPath, '/tmp/pending.png');
    });

    test('maps a server exception to a ServerFailure with its message',
        () async {
      remote.registerError = const ServerException('email_taken');

      final result = await register();

      expect(
        (result as Error<User>).failure.message,
        'email_taken',
      );
    });

    test('falls back to registration_failed when the server sends no message',
        () async {
      remote.registerError = const ServerException();

      final result = await register();

      expect(
        (result as Error<User>).failure.message,
        'errors.registration_failed',
      );
    });

    test('maps a connection exception to a ConnectionFailure', () async {
      remote.registerError = const ConnectionException('errors.network_error');

      final result = await register();

      expect((result as Error<User>).failure, isA<ConnectionFailure>());
    });

    test('maps unexpected errors to a generic ServerFailure', () async {
      remote.registerError = StateError('boom');

      final result = await register();

      expect(
        (result as Error<User>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('logout', () {
    test('clears credentials and the cached user', () async {
      credentials.access = 'access-1';
      local.cachedUser = _profileUser.toJson();

      final result = await repository.logout();

      expect(credentials.clearCalls, 1);
      expect(local.cachedUser, isNull);
      expect(result, isA<Success<void>>());
    });

    test('returns a cache failure when clearing the session fails', () async {
      credentials.clearError = StateError('boom');

      final result = await repository.logout();

      expect(
        (result as Error<void>).failure,
        isA<CacheFailure>().having(
          (f) => f.message,
          'message',
          'errors.clear_session_failed',
        ),
      );
    });
  });

  group('getCachedUser', () {
    test('returns null when no user is cached', () async {
      final result = await repository.getCachedUser();

      expect((result as Success<User?>).data, isNull);
    });

    test('returns the cached user parsed from storage', () async {
      local.cachedUser = _profileUser.toJson();

      final result = await repository.getCachedUser();

      final user = (result as Success<User?>).data;
      expect(user?.id, 'u1');
      expect(user?.firstName, 'Ana');
      expect(user?.isVerified, isTrue);
    });

    test('returns null when the cached user cannot be parsed', () async {
      local.cachedUser = {'id': 'u1'};

      final result = await repository.getCachedUser();

      expect((result as Success<User?>).data, isNull);
    });
  });

  group('forgotPassword', () {
    test('returns the server response', () async {
      remote.forgotPasswordResult = const {'status': 'sent'};

      final result = await repository.forgotPassword('ana@example.com');

      expect(remote.forgotEmail, 'ana@example.com');
      expect(
        (result as Success<Map<String, dynamic>>).data,
        {'status': 'sent'},
      );
    });

    test('maps a server exception to send_reset_email_failed', () async {
      remote.forgotPasswordError = const ServerException();

      final result = await repository.forgotPassword('a@b.c');

      expect(
        (result as Error<Map<String, dynamic>>).failure.message,
        'errors.send_reset_email_failed',
      );
    });

    test('maps a connection exception to a ConnectionFailure', () async {
      remote.forgotPasswordError = const ConnectionException(
        'errors.network_error',
      );

      final result = await repository.forgotPassword('a@b.c');

      final failure = (result as Error<Map<String, dynamic>>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'errors.network_error');
    });

    test('maps unexpected errors to a generic ServerFailure', () async {
      remote.forgotPasswordError = StateError('boom');

      final result = await repository.forgotPassword('a@b.c');

      expect(
        (result as Error<Map<String, dynamic>>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('resetPassword', () {
    test('returns success after resetting the password', () async {
      final result = await repository.resetPassword('tok', 'new-pw');

      expect(remote.resetToken, 'tok');
      expect(remote.resetNewPassword, 'new-pw');
      expect(result, isA<Success<void>>());
    });

    test('maps a server exception to reset_password_failed', () async {
      remote.resetPasswordError = const ServerException();

      final result = await repository.resetPassword('tok', 'new-pw');

      expect(
        (result as Error<void>).failure.message,
        'errors.reset_password_failed',
      );
    });

    test('maps a connection exception to a ConnectionFailure', () async {
      remote.resetPasswordError = const ConnectionException(
        'errors.network_error',
      );

      final result = await repository.resetPassword('tok', 'new-pw');

      final failure = (result as Error<void>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'errors.network_error');
    });

    test('maps unexpected errors to a generic ServerFailure', () async {
      remote.resetPasswordError = StateError('boom');

      final result = await repository.resetPassword('tok', 'new-pw');

      expect(
        (result as Error<void>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('socialLogin', () {
    test('persists tokens and caches the profile user on success', () async {
      final result = await repository.socialLogin(
        provider: 'google',
        email: 'ana@example.com',
      );

      expect(remote.socialProvider, 'google');
      expect(credentials.access, 'access-1');
      expect(credentials.refresh, 'refresh-1');
      expect(local.cachedUser, _profileUser.toJson());
      expect((result as Success<User>).data.id, 'u1');
    });

    test('maps a server exception to a ServerFailure with its message',
        () async {
      remote.socialLoginError = const ServerException('social_account_missing');

      final result = await repository.socialLogin(
        provider: 'google',
        email: 'ana@example.com',
      );

      expect(
        (result as Error<User>).failure.message,
        'social_account_missing',
      );
    });

    test('maps a connection exception to a ConnectionFailure', () async {
      remote.socialLoginError = const ConnectionException('errors.network_error');

      final result = await repository.socialLogin(
        provider: 'google',
        email: 'ana@example.com',
      );

      final failure = (result as Error<User>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'errors.network_error');
    });

    test('maps unexpected errors to a generic ServerFailure', () async {
      remote.socialLoginError = StateError('boom');

      final result = await repository.socialLogin(
        provider: 'google',
        email: 'ana@example.com',
      );

      expect(
        (result as Error<User>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('refreshSession', () {
    test('returns session_expired without calling the server when no refresh '
        'token is stored', () async {
      final result = await repository.refreshSession();

      expect(remote.refreshCalls, 0);
      expect(
        (result as Error<User>).failure,
        isA<ServerFailure>().having(
          (f) => f.message,
          'message',
          'errors.session_expired',
        ),
      );
      expect(credentials.clearCalls, 0);
    });

    test('refreshes tokens and caches the profile user', () async {
      credentials.refresh = 'stale-refresh';
      remote.refreshResponse = const LoginResponse(
        accessToken: 'new-access',
        refreshToken: 'new-refresh',
      );

      final result = await repository.refreshSession();

      expect(remote.refreshCalls, 1);
      expect(remote.refreshedToken, 'stale-refresh');
      expect(credentials.access, 'new-access');
      expect(credentials.refresh, 'new-refresh');
      expect(local.cachedUser, _profileUser.toJson());
      expect((result as Success<User>).data.id, 'u1');
    });

    test('clears the session when the server rejects the refresh token',
        () async {
      credentials.refresh = 'stale-refresh';
      remote.refreshError = const ServerException();

      final result = await repository.refreshSession();

      expect(credentials.clearCalls, 1);
      expect(local.cachedUser, isNull);
      expect(
        (result as Error<User>).failure.message,
        'errors.session_expired',
      );
    });

    test('keeps the session on a connection failure during refresh', () async {
      credentials.refresh = 'stale-refresh';
      remote.refreshError = const ConnectionException('errors.network_error');

      final result = await repository.refreshSession();

      expect(credentials.clearCalls, 0);
      expect(local.cachedUser, isNull);
      expect(
        (result as Error<User>).failure,
        isA<ConnectionFailure>().having(
          (f) => f.message,
          'message',
          'errors.network_error',
        ),
      );
    });

    test('clears the session on unexpected refresh errors', () async {
      credentials.refresh = 'stale-refresh';
      remote.refreshError = StateError('boom');

      final result = await repository.refreshSession();

      expect(credentials.clearCalls, 1);
      expect(local.cachedUser, isNull);
      expect(
        (result as Error<User>).failure.message,
        'errors.session_expired',
      );
    });
  });

  group('verifyEmail', () {
    test('returns success after verifying the email', () async {
      final result = await repository.verifyEmail('tok');

      expect(remote.verifyToken, 'tok');
      expect(result, isA<Success<void>>());
    });

    test('maps a server exception to verification_failed', () async {
      remote.verifyEmailError = const ServerException();

      final result = await repository.verifyEmail('tok');

      expect(
        (result as Error<void>).failure.message,
        'errors.verification_failed',
      );
    });

    test('maps a connection exception to a ConnectionFailure', () async {
      remote.verifyEmailError = const ConnectionException(
        'errors.network_error',
      );

      final result = await repository.verifyEmail('tok');

      final failure = (result as Error<void>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'errors.network_error');
    });

    test('maps unexpected errors to a generic ServerFailure', () async {
      remote.verifyEmailError = StateError('boom');

      final result = await repository.verifyEmail('tok');

      expect(
        (result as Error<void>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('resendVerification', () {
    test('returns success after resending verification', () async {
      final result = await repository.resendVerification('ana@example.com');

      expect(remote.resendEmail, 'ana@example.com');
      expect(result, isA<Success<void>>());
    });

    test('maps a server exception to resend_verification_failed', () async {
      remote.resendVerificationError = const ServerException();

      final result = await repository.resendVerification('a@b.c');

      expect(
        (result as Error<void>).failure.message,
        'errors.resend_verification_failed',
      );
    });

    test('maps a connection exception to a ConnectionFailure', () async {
      remote.resendVerificationError = const ConnectionException(
        'errors.network_error',
      );

      final result = await repository.resendVerification('a@b.c');

      final failure = (result as Error<void>).failure;
      expect(failure, isA<ConnectionFailure>());
      expect(failure.message, 'errors.network_error');
    });

    test('maps unexpected errors to a generic ServerFailure', () async {
      remote.resendVerificationError = StateError('boom');

      final result = await repository.resendVerification('a@b.c');

      expect(
        (result as Error<void>).failure.message,
        'errors.unexpected_error',
      );
    });
  });

  group('savePendingAvatar', () {
    test('stores the pending avatar path', () async {
      final result = await repository.savePendingAvatar('/tmp/a.png');

      expect(local.pendingAvatarPath, '/tmp/a.png');
      expect(result, isA<Success<void>>());
    });

    test('returns a cache failure when storing the path fails', () async {
      local.setPendingAvatarError = StateError('boom');

      final result = await repository.savePendingAvatar('/tmp/a.png');

      expect(
        (result as Error<void>).failure,
        isA<CacheFailure>().having(
          (f) => f.message,
          'message',
          'errors.avatar_save_failed',
        ),
      );
    });
  });
}

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  LoginResponse loginResponse = const LoginResponse(
    accessToken: 'access-1',
    refreshToken: 'refresh-1',
  );
  Object? loginError;
  RegisterResponse registerResponse = const RegisterResponse(
    user: _profileUser,
    accessToken: 'access-1',
    refreshToken: 'refresh-1',
  );
  Object? registerError;
  UserModel profileUser = _profileUser;
  Object? profileError;
  Object? uploadAvatarError;
  Object? uploadAvatarWithTokenError;
  Map<String, dynamic> forgotPasswordResult = const {};
  Object? forgotPasswordError;
  Object? resetPasswordError;
  LoginResponse socialLoginResponse = const LoginResponse(
    accessToken: 'access-1',
    refreshToken: 'refresh-1',
  );
  Object? socialLoginError;
  LoginResponse refreshResponse = const LoginResponse(
    accessToken: 'new-access',
    refreshToken: 'new-refresh',
  );
  Object? refreshError;
  Object? verifyEmailError;
  Object? resendVerificationError;

  int refreshCalls = 0;
  int uploadAvatarCalls = 0;
  int uploadAvatarWithTokenCalls = 0;
  String? lastUploadedPath;
  String? lastUploadToken;
  String? forgotEmail;
  String? resetToken;
  String? resetNewPassword;
  String? socialProvider;
  String? refreshedToken;
  String? verifyToken;
  String? resendEmail;

  @override
  Future<LoginResponse> login(String email, String password) async {
    final error = loginError;
    if (error != null) throw error;
    return loginResponse;
  }

  @override
  Future<RegisterResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    String? state,
    String? city,
    DateTime? dateOfBirth,
  }) async {
    final error = registerError;
    if (error != null) throw error;
    return registerResponse;
  }

  @override
  Future<UserModel> getProfile() async {
    final error = profileError;
    if (error != null) throw error;
    return profileUser;
  }

  @override
  Future<void> uploadAvatar(String filePath) async {
    final error = uploadAvatarError;
    if (error != null) throw error;
    uploadAvatarCalls++;
    lastUploadedPath = filePath;
  }

  @override
  Future<void> uploadAvatarWithToken(
    String filePath,
    String accessToken,
  ) async {
    final error = uploadAvatarWithTokenError;
    if (error != null) throw error;
    uploadAvatarWithTokenCalls++;
    lastUploadedPath = filePath;
    lastUploadToken = accessToken;
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final error = forgotPasswordError;
    if (error != null) throw error;
    forgotEmail = email;
    return forgotPasswordResult;
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    final error = resetPasswordError;
    if (error != null) throw error;
    resetToken = token;
    resetNewPassword = newPassword;
  }

  @override
  Future<LoginResponse> socialLogin({
    required String provider,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    final error = socialLoginError;
    if (error != null) throw error;
    socialProvider = provider;
    return socialLoginResponse;
  }

  @override
  Future<LoginResponse> refreshToken(String refreshToken) async {
    final error = refreshError;
    if (error != null) throw error;
    refreshCalls++;
    refreshedToken = refreshToken;
    return refreshResponse;
  }

  @override
  Future<void> verifyEmail(String token) async {
    final error = verifyEmailError;
    if (error != null) throw error;
    verifyToken = token;
  }

  @override
  Future<void> resendVerification(String email) async {
    final error = resendVerificationError;
    if (error != null) throw error;
    resendEmail = email;
  }
}

class _FakeLocalStorage extends LocalStorageService {
  Map<String, dynamic>? cachedUser;
  String? pendingAvatarPath;
  Object? setPendingAvatarError;
  Object? clearCachedUserError;

  @override
  Future<void> cacheUser(Map<String, dynamic> userJson) async {
    cachedUser = userJson;
  }

  @override
  Map<String, dynamic>? getCachedUser() => cachedUser;

  @override
  Future<void> clearCachedUser() async {
    if (clearCachedUserError != null) throw clearCachedUserError!;
    cachedUser = null;
  }

  @override
  Future<void> setPendingAvatarPath(String path) async {
    if (setPendingAvatarError != null) throw setPendingAvatarError!;
    pendingAvatarPath = path;
  }

  @override
  String? getPendingAvatarPath() => pendingAvatarPath;

  @override
  Future<void> clearPendingAvatarPath() async {
    pendingAvatarPath = null;
  }
}

class _FakeCredentials implements CredentialStorage {
  String? access;
  String? refresh;
  Object? clearError;
  int clearCalls = 0;
  int refreshWrites = 0;

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => refresh;

  @override
  Future<void> writeAccessToken(String token) async => access = token;

  @override
  Future<void> writeRefreshToken(String token) async {
    refreshWrites++;
    refresh = token;
  }

  @override
  Future<void> clear() async {
    if (clearError != null) throw clearError!;
    clearCalls++;
    access = null;
    refresh = null;
  }
}
