/// Arguments passed to the [AppRoutes.verifyEmail] route.
class VerifyEmailArgs {
  final String email;

  /// When true, the verification screen will automatically call
  /// [AuthCubit.resendVerification] on mount to generate a fresh token.
  /// Set to true when navigating from the login flow (unverified email).
  /// Set to false when navigating from registration (token already issued).
  final bool autoResend;

  const VerifyEmailArgs({required this.email, this.autoResend = false});
}
