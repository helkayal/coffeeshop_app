import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/result.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_session_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/resend_verification_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/save_pending_avatar_usecase.dart';
import '../../domain/usecases/social_login_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final RefreshSessionUseCase _refreshSessionUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendVerificationUseCase _resendVerificationUseCase;
  final LogoutUseCase _logoutUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final SocialLoginUseCase _socialLoginUseCase;
  final SavePendingAvatarUseCase _savePendingAvatarUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required RefreshSessionUseCase refreshSessionUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required ResendVerificationUseCase resendVerificationUseCase,
    required LogoutUseCase logoutUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required SocialLoginUseCase socialLoginUseCase,
    required SavePendingAvatarUseCase savePendingAvatarUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _refreshSessionUseCase = refreshSessionUseCase,
       _verifyEmailUseCase = verifyEmailUseCase,
       _resendVerificationUseCase = resendVerificationUseCase,
       _logoutUseCase = logoutUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _socialLoginUseCase = socialLoginUseCase,
       _savePendingAvatarUseCase = savePendingAvatarUseCase,
       super(const AuthInitial());

  Future<void> savePendingAvatar(String path) async {
    final result = await _savePendingAvatarUseCase(path);
    result.fold((failure) => emit(AuthError(failure.message)), (_) {});
  }

  Future<void> refreshSession() async {
    if (isClosed) return;
    emit(const AuthSessionRefreshing());
    final result = await _refreshSessionUseCase();
    if (isClosed) return;
    result.fold(
      (_) => emit(const AuthSessionExpired()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> login(String email, String password) async {
    if (isClosed) return;
    emit(const AuthLoading());
    final result = await _loginUseCase(email, password);
    if (isClosed) return;
    result.fold((failure) {
      final msg = failure.message.toLowerCase();
      if (msg.contains('not verified') || msg.contains('email not verified')) {
        emit(AuthEmailNotVerified(email));
      } else {
        emit(AuthError(failure.message));
      }
    }, (user) => emit(AuthAuthenticated(user)));
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    String? state,
    String? city,
    DateTime? dateOfBirth,
  }) async {
    if (isClosed) return;
    emit(const AuthLoading());
    final result = await _registerUseCase(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      gender: gender,
      state: state,
      city: city,
      dateOfBirth: dateOfBirth,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthRegisterSuccess(email)),
    );
  }

  Future<void> verifyEmail(String token) async {
    if (isClosed) return;
    emit(const AuthLoading());
    final result = await _verifyEmailUseCase(token);
    if (isClosed) return;
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthVerifyEmailSuccess()),
    );
  }

  Future<void> resendVerification(String email) async {
    if (isClosed) return;
    emit(const AuthLoading());
    final result = await _resendVerificationUseCase(email);
    if (isClosed) return;
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthInitial()),
    );
  }

  Future<void> logout() async {
    await _logoutUseCase();
    if (!isClosed) emit(const AuthInitial());
  }

  Future<Result<Map<String, dynamic>>> forgotPassword(String email) =>
      _forgotPasswordUseCase(email);

  Future<Result<void>> resetPassword(String token, String newPassword) =>
      _resetPasswordUseCase(token, newPassword);

  Future<void> socialLogin({
    required String provider,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    if (isClosed) return;
    emit(const AuthLoading());
    final result = await _socialLoginUseCase(
      provider: provider,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
