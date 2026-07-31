import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/refresh_session_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/resend_verification_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final RefreshSessionUseCase _refreshSessionUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendVerificationUseCase _resendVerificationUseCase;
  final AuthRepository _authRepository;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required RefreshSessionUseCase refreshSessionUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required ResendVerificationUseCase resendVerificationUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _refreshSessionUseCase = refreshSessionUseCase,
        _verifyEmailUseCase = verifyEmailUseCase,
        _resendVerificationUseCase = resendVerificationUseCase,
        _authRepository = authRepository,
        super(const AuthInitial());

  /// Called at app startup from [SplashScreen].
  /// Uses the stored refresh token to get a new session.
  /// Emits [AuthAuthenticated] on success or [AuthSessionExpired] on failure.
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
    result.fold(
      (failure) {
        final msg = failure.message.toLowerCase();
        if (msg.contains('not verified') || msg.contains('email not verified')) {
          emit(AuthEmailNotVerified(email));
        } else {
          emit(AuthError(failure.message));
        }
      },
      (user) => emit(AuthAuthenticated(user)),
    );
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
    await _authRepository.logout();
    if (!isClosed) emit(const AuthInitial());
  }

  Future<Result<Map<String, dynamic>>> forgotPassword(String email) {
    return _authRepository.forgotPassword(email);
  }

  Future<Result<void>> resetPassword(String token, String newPassword) {
    return _authRepository.resetPassword(token, newPassword);
  }

  Future<void> socialLogin({
    required String provider,
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    if (isClosed) return;
    emit(const AuthLoading());
    final result = await _authRepository.socialLogin(
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
