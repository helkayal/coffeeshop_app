import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/app_text_field.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.emailError,
    this.passwordError,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        AppTextField(
          controller: emailController,
          hintText: 'auth.email_address'.tr(),
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.email_outlined, color: colorScheme.outline),
          errorText: emailError,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: passwordController,
          hintText: 'auth.password'.tr(),
          isPassword: true,
          prefixIcon: Icon(Icons.lock_outline, color: colorScheme.outline),
          errorText: passwordError,
        ),
      ],
    );
  }
}
