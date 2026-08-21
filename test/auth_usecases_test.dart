import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/auth/domain/entities/user.dart';
import 'package:coffeeshop_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/get_cached_user.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/refresh_session_usecase.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/resend_verification_usecase.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/save_pending_avatar_usecase.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/social_login_usecase.dart';
import 'package:coffeeshop_app/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

const _user = User(
  id: 'u1',
  firstName: 'Ana',
  lastName: 'S',
  email: 'ana@example.com',
);
const _loginError = Error<User>(ServerFailure('errors.invalid_credentials'));

void main() {
  late _FakeAuthRepository repository;

  setUp(() {
    repository = _FakeAuthRepository();
  });

  group('LoginUseCase', () {
    test('forwards credentials to the repository and returns the user', () async {
      final result = await LoginUseCase(repository)('ana@example.com', 'pw');

      expect(repository.loginEmail, 'ana@example.com');
      expect(repository.loginPassword, 'pw');
      expect((result as Success<User>).data, _user);
    });

    test('propagates a login failure', () async {
      repository.loginResult = _loginError;

      final result = await LoginUseCase(repository)('a@b.c', 'pw');

      expect(result, isA<Error<User>>());
      expect((result as Error<User>).failure.message, 'errors.invalid_credentials');
    });
  });

  group('RegisterUseCase', () {
    test('forwards all registration fields to the repository', () async {
      final dateOfBirth = DateTime(2000, 5, 1);
      final result = await RegisterUseCase(repository)(
        firstName: 'Ana',
        lastName: 'S',
        email: 'ana@example.com',
        password: 'pw',
        gender: 'female',
        state: 'NY',
        city: 'NYC',
        dateOfBirth: dateOfBirth,
      );

      expect(repository.registerFirstName, 'Ana');
      expect(repository.registerLastName, 'S');
      expect(repository.registerEmail, 'ana@example.com');
      expect(repository.registerPassword, 'pw');
      expect(repository.registerGender, 'female');
      expect(repository.registerState, 'NY');
      expect(repository.registerCity, 'NYC');
      expect(repository.registerDateOfBirth, dateOfBirth);
      expect((result as Success<User>).data, _user);
    });

    test('propagates a registration failure', () async {
      repository.registerResult = _loginError;

      final result = await RegisterUseCase(repository)(
        firstName: 'Ana',
        lastName: 'S',
        email: 'ana@example.com',
        password: 'pw',
        gender: 'female',
      );

      expect(result, isA<Error<User>>());
    });
  });

  group('LogoutUseCase', () {
    test('forwards logout to the repository', () async {
      final result = await LogoutUseCase(repository)();

      expect(repository.logoutCalls, 1);
      expect(result, isA<Success<void>>());
    });

    test('propagates a logout failure', () async {
      repository.logoutResult = const Error<void>(ServerFailure('logout_failed'));

      final result = await LogoutUseCase(repository)();

      expect((result as Error<void>).failure.message, 'logout_failed');
    });
  });

  group('RefreshSessionUseCase', () {
    test('forwards the session refresh request and returns the user', () async {
      final result = await RefreshSessionUseCase(repository)();

      expect(repository.refreshCalls, 1);
      expect((result as Success<User>).data, _user);
    });

    test('propagates a refresh failure', () async {
      repository.refreshResult = _loginError;

      final result = await RefreshSessionUseCase(repository)();

      expect(result, isA<Error<User>>());
    });
  });

  group('ForgotPasswordUseCase', () {
    test('forwards the email and returns the server response', () async {
      const response = {'status': 'sent'};
      repository.forgotPasswordResult = const Success<Map<String, dynamic>>(
        {'status': 'sent'},
      );

      final result = await ForgotPasswordUseCase(repository)('ana@example.com');

      expect(repository.forgotEmail, 'ana@example.com');
      expect((result as Success<Map<String, dynamic>>).data, response);
    });

    test('propagates a forgot-password failure', () async {
      repository.forgotPasswordResult = const Error<Map<String, dynamic>>(
        ServerFailure('errors.send_reset_email_failed'),
      );

      final result = await ForgotPasswordUseCase(repository)('a@b.c');

      expect(
        (result as Error<Map<String, dynamic>>).failure.message,
        'errors.send_reset_email_failed',
      );
    });
  });

  group('ResetPasswordUseCase', () {
    test('forwards the token and new password', () async {
      final result = await ResetPasswordUseCase(repository)('tok', 'new-pw');

      expect(repository.resetToken, 'tok');
      expect(repository.resetNewPassword, 'new-pw');
      expect(result, isA<Success<void>>());
    });

    test('propagates a reset-password failure', () async {
      repository.resetPasswordResult = const Error<void>(
        ServerFailure('errors.reset_password_failed'),
      );

      final result = await ResetPasswordUseCase(repository)('tok', 'new-pw');

      expect(
        (result as Error<void>).failure.message,
        'errors.reset_password_failed',
      );
    });
  });

  group('VerifyEmailUseCase', () {
    test('forwards the verification token', () async {
      final result = await VerifyEmailUseCase(repository)('tok');

      expect(repository.verifyToken, 'tok');
      expect(result, isA<Success<void>>());
    });

    test('propagates a verification failure', () async {
      repository.verifyEmailResult = const Error<void>(
        ServerFailure('errors.verification_failed'),
      );

      final result = await VerifyEmailUseCase(repository)('tok');

      expect(
        (result as Error<void>).failure.message,
        'errors.verification_failed',
      );
    });
  });

  group('ResendVerificationUseCase', () {
    test('forwards the email address', () async {
      final result = await ResendVerificationUseCase(repository)(
        'ana@example.com',
      );

      expect(repository.resendEmail, 'ana@example.com');
      expect(result, isA<Success<void>>());
    });

    test('propagates a resend failure', () async {
      repository.resendVerificationResult = const Error<void>(
        ServerFailure('errors.resend_verification_failed'),
      );

      final result = await ResendVerificationUseCase(repository)('a@b.c');

      expect(
        (result as Error<void>).failure.message,
        'errors.resend_verification_failed',
      );
    });
  });

  group('SocialLoginUseCase', () {
    test('forwards social login details and returns the user', () async {
      final result = await SocialLoginUseCase(repository)(
        provider: 'google',
        email: 'ana@example.com',
        firstName: 'Ana',
        lastName: 'S',
      );

      expect(repository.socialProvider, 'google');
      expect(repository.socialEmail, 'ana@example.com');
      expect(repository.socialFirstName, 'Ana');
      expect(repository.socialLastName, 'S');
      expect((result as Success<User>).data, _user);
    });

    test('propagates a social login failure', () async {
      repository.socialLoginResult = _loginError;

      final result = await SocialLoginUseCase(repository)(
        provider: 'google',
        email: 'ana@example.com',
      );

      expect(result, isA<Error<User>>());
    });
  });

  group('SavePendingAvatarUseCase', () {
    test('forwards the avatar path to the repository', () async {
      final result = await SavePendingAvatarUseCase(repository)('/tmp/a.png');

      expect(repository.avatarPath, '/tmp/a.png');
      expect(result, isA<Success<void>>());
    });

    test('propagates an avatar save failure', () async {
      repository.savePendingAvatarResult = const Error<void>(
        CacheFailure('errors.avatar_save_failed'),
      );

      final result = await SavePendingAvatarUseCase(repository)('/tmp/a.png');

      expect(
        (result as Error<void>).failure.message,
        'errors.avatar_save_failed',
      );
    });
  });

  group('GetCachedUserUseCase', () {
    test('returns the cached user from the repository', () async {
      final result = await GetCachedUserUseCase(repository)();

      expect(repository.cachedUserCalls, 1);
      expect((result as Success<User?>).data, _user);
    });

    test('propagates a cache read failure', () async {
      repository.cachedUserResult = const Error<User?>(
        CacheFailure('errors.cache_error'),
      );

      final result = await GetCachedUserUseCase(repository)();

      expect((result as Error<User?>).failure, isA<CacheFailure>());
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  Result<User>? loginResult;
  Result<User>? registerResult;
  Result<void>? logoutResult;
  Result<User?>? cachedUserResult;
  Result<Map<String, dynamic>>? forgotPasswordResult;
  Result<void>? resetPasswordResult;
  Result<User>? socialLoginResult;
  Result<User>? refreshResult;
  Result<void>? verifyEmailResult;
  Result<void>? resendVerificationResult;
  Result<void>? savePendingAvatarResult;

  String? loginEmail;
  String? loginPassword;
  String? registerFirstName;
  String? registerLastName;
  String? registerEmail;
  String? registerPassword;
  String? registerGender;
  String? registerState;
  String? registerCity;
  DateTime? registerDateOfBirth;
  int logoutCalls = 0;
  int refreshCalls = 0;
  int cachedUserCalls = 0;
  String? forgotEmail;
  String? resetToken;
  String? resetNewPassword;
  String? socialProvider;
  String? socialEmail;
  String? socialFirstName;
  String? socialLastName;
  String? verifyToken;
  String? resendEmail;
  String? avatarPath;

  @override
  Future<Result<User>> login(String email, String password) async {
    loginEmail = email;
    loginPassword = password;
    return loginResult ?? const Success(_user);
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
    registerFirstName = firstName;
    registerLastName = lastName;
    registerEmail = email;
    registerPassword = password;
    registerGender = gender;
    registerState = state;
    registerCity = city;
    registerDateOfBirth = dateOfBirth;
    return registerResult ?? const Success(_user);
  }

  @override
  Future<Result<void>> logout() async {
    logoutCalls++;
    return logoutResult ?? const Success(null);
  }

  @override
  Future<Result<User?>> getCachedUser() async {
    cachedUserCalls++;
    return cachedUserResult ?? const Success(_user);
  }

  @override
  Future<Result<Map<String, dynamic>>> forgotPassword(String email) async {
    forgotEmail = email;
    return forgotPasswordResult ??
        const Success<Map<String, dynamic>>({'status': 'sent'});
  }

  @override
  Future<Result<void>> resetPassword(String token, String newPassword) async {
    resetToken = token;
    resetNewPassword = newPassword;
    return resetPasswordResult ?? const Success(null);
  }

  @override
  Future<Result<User>> socialLogin({
    required String provider,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    socialProvider = provider;
    socialEmail = email;
    socialFirstName = firstName;
    socialLastName = lastName;
    return socialLoginResult ?? const Success(_user);
  }

  @override
  Future<Result<User>> refreshSession() async {
    refreshCalls++;
    return refreshResult ?? const Success(_user);
  }

  @override
  Future<Result<void>> verifyEmail(String token) async {
    verifyToken = token;
    return verifyEmailResult ?? const Success(null);
  }

  @override
  Future<Result<void>> resendVerification(String email) async {
    resendEmail = email;
    return resendVerificationResult ?? const Success(null);
  }

  @override
  Future<Result<void>> savePendingAvatar(String path) async {
    avatarPath = path;
    return savePendingAvatarResult ?? const Success(null);
  }
}
