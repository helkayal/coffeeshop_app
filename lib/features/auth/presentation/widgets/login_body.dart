import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/adaptive_content.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_header.dart';
import 'login_form.dart';
import 'register_link.dart';
import 'social_login_section.dart';

class LoginBody extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLoginPressed;
  final VoidCallback onForgotPassword;
  final void Function(String provider) onSocialLogin;
  final String? emailError;
  final String? passwordError;

  const LoginBody({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLoginPressed,
    required this.onForgotPassword,
    required this.onSocialLogin,
    this.emailError,
    this.passwordError,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdaptiveContent(
      maxWidth: AppBreakpoints.formMaxWidth,
      child: SingleChildScrollView(
        padding: AppInsets.h24,
        child: Column(
          children: [
            AuthHeader(
              title: 'auth.welcome_back'.tr(),
              subtitle: 'auth.login_subtitle'.tr(),
            ),
            AppSpacing.v48,
            LoginForm(
              emailController: emailController,
              passwordController: passwordController,
              emailError: emailError,
              passwordError: passwordError,
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: onForgotPassword,
                child: Text(
                  'auth.forgot_password'.tr(),
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            AppSpacing.v24,
            AppButton(
              text: 'auth.sign_in'.tr(),
              isLoading: isLoading,
              onPressed: isLoading ? () {} : onLoginPressed,
            ),
            AppSpacing.v16,
            const RegisterLink(),
            AppSpacing.v32,
            SocialLoginSection(onSocialLogin: onSocialLogin),
            AppSpacing.v40,
          ],
        ),
      ),
    );
  }
}
