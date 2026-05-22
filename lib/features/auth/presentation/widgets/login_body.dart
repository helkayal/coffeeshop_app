import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_design_constants.dart';
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

  const LoginBody({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignConstants.paddingLarge,
      ),
      child: Column(
        children: [
          AuthHeader(
            title: 'auth.welcome_back'.tr(),
            subtitle: 'auth.login_subtitle'.tr(),
          ),
          const SizedBox(height: 48),
          LoginForm(
            emailController: emailController,
            passwordController: passwordController,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'auth.forgot_password'.tr(),
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'auth.sign_in'.tr(),
            isLoading: isLoading,
            onPressed: isLoading ? () {} : onLoginPressed,
          ),
          const SizedBox(height: 16),
          const RegisterLink(),
          const SizedBox(height: 32),
          const SocialLoginSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
