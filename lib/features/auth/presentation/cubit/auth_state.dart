import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSessionRefreshing extends AuthState {
  const AuthSessionRefreshing();
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthSessionExpired extends AuthState {
  const AuthSessionExpired();
}

/// Emitted when the user tries to log in but hasn't verified their email yet.
class AuthEmailNotVerified extends AuthState {
  final String email;
  const AuthEmailNotVerified(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthVerifyEmailSuccess extends AuthState {
  const AuthVerifyEmailSuccess();
}

class AuthRegisterSuccess extends AuthState {
  final String email;
  const AuthRegisterSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
