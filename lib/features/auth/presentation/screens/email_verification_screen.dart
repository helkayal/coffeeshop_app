import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Shown after registration or when a login attempt is blocked due to
/// an unverified email. Accepts the verification token and optionally
/// lets the user request a new one.
class EmailVerificationScreen extends StatelessWidget {
  final String email;
  final bool autoResend;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.autoResend = false,
  });

  @override
  Widget build(BuildContext context) {
    return _EmailVerificationContent(email: email, autoResend: autoResend);
  }
}

class _EmailVerificationContent extends StatefulWidget {
  final String email;
  final bool autoResend;

  const _EmailVerificationContent({
    required this.email,
    required this.autoResend,
  });

  @override
  State<_EmailVerificationContent> createState() =>
      _EmailVerificationContentState();
}

class _EmailVerificationContentState extends State<_EmailVerificationContent> {
  final _tokenController = TextEditingController();
  bool _manualResendTriggered = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoResend) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Silent background call — no snackbar shown.
          context.read<AuthCubit>().resendVerification(widget.email);
        }
      });
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  void _onVerify() {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      AppSnackBar.show(
        context,
        'verification.token_empty'.tr(),
        type: SnackBarType.error,
      );
      return;
    }
    context.read<AuthCubit>().verifyEmail(token);
  }

  void _onResend() {
    _manualResendTriggered = true;
    context.read<AuthCubit>().resendVerification(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('verification.title'.tr()), centerTitle: true),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthVerifyEmailSuccess) {
            AppSnackBar.show(
              context,
              'verification.success_message'.tr(),
              type: SnackBarType.success,
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          } else if (state is AuthInitial) {
            // Only show the snackbar when the user manually tapped Resend.
            if (_manualResendTriggered) {
              _manualResendTriggered = false;
              AppSnackBar.show(
                context,
                'verification.resent_message'.tr(),
                type: SnackBarType.success,
              );
            }
          } else if (state is AuthError) {
            AppSnackBar.show(context, state.message, type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 72,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'verification.title'.tr(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'verification.message'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    controller: _tokenController,
                    label: 'verification.token_label'.tr(),
                    prefixIcon: const Icon(Icons.verified_outlined),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : _onVerify,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text('verification.verify'.tr()),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: isLoading ? null : _onResend,
                    child: Text('verification.resend'.tr()),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    ),
                    child: Text('verification.skip'.tr()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
