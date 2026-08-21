import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/form_validators.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../screens/verify_email_args.dart';
import 'forgot_password_dialog.dart';
import 'login_body.dart';
import 'reset_password_dialog.dart';
import 'social_login_dialog.dart';

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({super.key});

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    if (_emailError == null) return;
    setState(() => _emailError = _validateEmail(_emailController.text.trim()));
  }

  void _onPasswordChanged() {
    if (_passwordError == null) return;
    setState(
      () => _passwordError = _validatePassword(_passwordController.text),
    );
  }

  String? _validateEmail(String email) =>
      FormValidators.validateEmail(email)?.tr();

  // Login only needs presence + length — no common/similarity checks.
  String? _validatePassword(String password) =>
      FormValidators.validateLoginPassword(password)?.tr();

  bool _validate() {
    final emailError = _validateEmail(_emailController.text.trim());
    final passwordError = _validatePassword(_passwordController.text);
    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });
    return emailError == null && passwordError == null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (!_validate()) return;
    context.read<AuthCubit>().login(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  Future<void> _onForgotPassword() async {
    // Use a StatefulWidget dialog so its controllers are owned by the dialog's
    // State and disposed only after the pop animation fully completes — never
    // while the animation is still running. This prevents the "controller used
    // after dispose" crash that occurs when AuthLoading rebuilds the tree
    // during the dialog's close animation.
    final email = await showDialog<String>(
      context: context,
      builder: (_) => const ForgotPasswordDialog(),
    );

    if (email == null || !mounted) return;

    // showDialog has fully resolved — dialog is 100% gone from the tree.
    // Safe to call cubit and trigger state changes.
    final cubit = context.read<AuthCubit>();
    final result = await cubit.forgotPassword(email);
    if (!mounted) return;
    result.fold(
      (failure) => AppSnackBar.show(
        context,
        failure.message,
        type: SnackBarType.error,
      ),
      (data) => _showResetTokenDialog(data, email),
    );
  }

  Future<void> _showResetTokenDialog(
    Map<String, dynamic> data,
    String email,
  ) async {
    final token = data['token'] as String? ?? '';
    final cubit = context.read<AuthCubit>();

    final newPassword = await showDialog<String>(
      context: context,
      builder: (_) => ResetPasswordDialog(
        token: token,
        email: email,
        onSubmit: (password) => cubit.resetPassword(token, password),
      ),
    );
    if (newPassword == null || !mounted) return;

    AppSnackBar.show(
      context,
      'verification.reset_success_message'.tr(),
      type: SnackBarType.success,
    );
  }

  Future<void> _onSocialLogin(String provider) async {
    // Same pattern: StatefulWidget dialog owns its controllers.
    // Cubit is called only after showDialog resolves (dialog fully gone).
    final result = await showDialog<({String email, String? firstName, String? lastName})>(
      context: context,
      builder: (_) => SocialLoginDialog(provider: provider),
    );

    if (result == null || !mounted) return;
    context.read<AuthCubit>().socialLogin(
      provider: provider,
      email: result.email,
      firstName: result.firstName,
      lastName: result.lastName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            switch (state) {
              case AuthError():
                AppSnackBar.show(
                  context,
                  state.message,
                  type: SnackBarType.error,
                );
              case AuthAuthenticated():
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false,
                );
              case AuthEmailNotVerified():
                Navigator.pushNamed(
                  context,
                  AppRoutes.verifyEmail,
                  arguments: VerifyEmailArgs(
                    email: state.email,
                    autoResend: true,
                  ),
                );
              default:
                break;
            }
          },
          builder: (context, state) => LoginBody(
            emailController: _emailController,
            passwordController: _passwordController,
            isLoading: state is AuthLoading,
            onLoginPressed: _onLoginPressed,
            onForgotPassword: _onForgotPassword,
            onSocialLogin: _onSocialLogin,
            emailError: _emailError,
            passwordError: _passwordError,
          ),
        ),
      ),
    );
  }
}
