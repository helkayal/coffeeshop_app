import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _LoginScreenContent(),
    );
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.show(context, 'auth.please_fill_all_fields'.tr(), type: SnackBarType.error);
      return;
    }

    context.read<AuthCubit>().login(email, password);
  }

  void _showVerificationAlert(BuildContext context, String message) {
    final tokenCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('verification.email_not_verified'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 16),
            AppTextField(
              controller: tokenCtrl,
              label: 'verification.token_label'.tr(),
              prefixIcon: const Icon(Icons.verified_outlined),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          FilledButton(
            onPressed: () async {
              final token = tokenCtrl.text.trim();
              if (token.isEmpty) return;
              try {
                await sl<ApiService>().post(
                  ApiConstants.verifyEmail,
                  data: {'token': token},
                );
                Navigator.pop(context);
                AppSnackBar.show(context, 'Email verified! Please login.',
                    type: SnackBarType.success);
              } catch (_) {
                AppSnackBar.show(context, 'Invalid or expired token',
                    type: SnackBarType.error);
              }
            },
            child: Text('verification.verify'.tr()),
          ),
        ],
      ),
    );
  }

  void _onForgotPassword() {
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('verification.forgot_password'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('verification.forgot_password_msg'.tr()),
            const SizedBox(height: 16),
            AppTextField(
              controller: emailCtrl,
              hintText: 'auth.email_address'.tr(),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          FilledButton(
            onPressed: () async {
              final email = emailCtrl.text.trim();
              if (email.isEmpty) return;
              Navigator.pop(context);

              final cubit = context.read<AuthCubit>();
              final result = await cubit.forgotPassword(email);
              if (context.mounted) {
                result.fold(
                  (failure) => AppSnackBar.show(context, failure.message, type: SnackBarType.error),
                  (data) => _showResetTokenDialog(data),
                );
              }
            },
            child: Text('verification.send'.tr()),
          ),
        ],
      ),
    );
  }

  void _showResetTokenDialog(Map<String, dynamic> data) {
    final token = data['token'] as String? ?? '';
    final newPwdCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('verification.reset_password'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('verification.reset_token_msg'.tr()),
            const SizedBox(height: 12),
            AppTextField(
              label: 'verification.reset_token_label'.tr(),
              controller: TextEditingController(text: token),
              prefixIcon: const Icon(Icons.key),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: newPwdCtrl,
              label: 'verification.new_password'.tr(),
              isPassword: true,
              prefixIcon: const Icon(Icons.lock_outlined),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          FilledButton(
            onPressed: () async {
              final newPassword = newPwdCtrl.text;
              if (newPassword.length < 8) return;
              Navigator.pop(context);

              final cubit = context.read<AuthCubit>();
              final result = await cubit.resetPassword(token, newPassword);
              if (context.mounted) {
                result.fold(
                  (failure) => AppSnackBar.show(context, failure.message, type: SnackBarType.error),
                  (_) {
                    AppSnackBar.show(context, 'Password reset successfully. Please login.',
                        type: SnackBarType.success);
                  },
                );
              }
            },
            child: Text('verification.reset'.tr()),
          ),
        ],
      ),
    );
  }

  void _onSocialLogin(String provider) {
    final emailCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sign in with $provider'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: emailCtrl,
              hintText: 'auth.email_address'.tr(),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: nameCtrl,
              hintText: 'Full Name (optional)',
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              final email = emailCtrl.text.trim();
              if (email.isEmpty) return;
              Navigator.pop(context);

              final names = nameCtrl.text.trim().split(' ');
              context.read<AuthCubit>().socialLogin(
                provider: provider,
                email: email,
                firstName: names.isNotEmpty ? names.first : null,
                lastName: names.length > 1 ? names.sublist(1).join(' ') : null,
              );
            },
            child: Text('Sign in with $provider'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              if (state.message.contains('not verified')) {
                _showVerificationAlert(context, state.message);
              } else {
                AppSnackBar.show(context, state.message, type: SnackBarType.error);
              }
            } else if (state is AuthAuthenticated) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            }
          },
          builder: (context, state) => LoginBody(
            emailController: _emailController,
            passwordController: _passwordController,
            isLoading: state is AuthLoading,
            onLoginPressed: _onLoginPressed,
            onForgotPassword: _onForgotPassword,
            onSocialLogin: _onSocialLogin,
          ),
        ),
      ),
    );
  }
}
