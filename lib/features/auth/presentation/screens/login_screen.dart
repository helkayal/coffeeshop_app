import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/password_validator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../screens/verify_email_args.dart';
import '../widgets/login_body.dart';
import '../widgets/reset_password_dialog.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginScreenContent();
  }
}

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
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

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'validation.email_required'.tr();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'validation.email_invalid'.tr();
    }
    return null;
  }

  // Login only needs presence + length — no common/similarity checks.
  String? _validatePassword(String password) {
    if (password.isEmpty) return 'validation.password_required'.tr();
    if (password.length < 8) return 'validation.password_min_length'.tr();
    if (RegExp(r'^\d+$').hasMatch(password)) {
      return PasswordValidator.numericErrorKey.tr();
    }
    return null;
  }

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
      builder: (_) => const _ForgotPasswordDialog(),
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
      builder: (_) => _SocialLoginDialog(provider: provider),
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

// ---------------------------------------------------------------------------
// Private dialog widgets — each owns its own TextEditingControllers.
//
// Flutter calls State.dispose() AFTER the pop animation fully completes,
// so the controllers are guaranteed alive during the entire close animation.
// This eliminates the race between the animation rebuild and controller
// disposal that caused the "controller used after dispose" assertion.
// ---------------------------------------------------------------------------

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog();

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('verification.forgot_password'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('verification.forgot_password_msg'.tr()),
            AppSpacing.v16,
            AppTextField(
              controller: _emailCtrl,
              hintText: 'auth.email_address'.tr(),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        FilledButton(
          onPressed: () {
            final email = _emailCtrl.text.trim();
            if (email.isEmpty) return;
            Navigator.pop(context, email);
          },
          child: Text('verification.send'.tr()),
        ),
      ],
    );
  }
}

class _SocialLoginDialog extends StatefulWidget {
  final String provider;

  const _SocialLoginDialog({required this.provider});

  @override
  State<_SocialLoginDialog> createState() => _SocialLoginDialogState();
}

class _SocialLoginDialogState extends State<_SocialLoginDialog> {
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'auth.social_sign_in'.tr(namedArgs: {'provider': widget.provider}),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _emailCtrl,
              hintText: 'auth.email_address'.tr(),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            AppSpacing.v12,
            AppTextField(
              controller: _nameCtrl,
              hintText: 'auth.full_name_optional'.tr(),
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        FilledButton(
          onPressed: () {
            final email = _emailCtrl.text.trim();
            if (email.isEmpty) return;
            final names = _nameCtrl.text.trim().split(' ');
            Navigator.pop(
              context,
              (
                email: email,
                firstName: names.isNotEmpty ? names.first : null,
                lastName:
                    names.length > 1 ? names.sublist(1).join(' ') : null,
              ),
            );
          },
          child: Text(
            'auth.social_sign_in'.tr(namedArgs: {'provider': widget.provider}),
          ),
        ),
      ],
    );
  }
}
