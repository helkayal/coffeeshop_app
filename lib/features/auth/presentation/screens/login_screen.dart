import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_snack_bar.dart';
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
      AppSnackBar.show(context, 'auth.please_fill_all_fields'.tr());
      return;
    }

    // context.read<AuthCubit>().login(email, password);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              AppSnackBar.show(context, state.message);
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
          ),
        ),
      ),
    );
  }
}
