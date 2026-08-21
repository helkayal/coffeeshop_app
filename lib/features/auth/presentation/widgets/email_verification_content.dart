import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class EmailVerificationContent extends StatefulWidget {
  final String email;
  final bool autoResend;

  const EmailVerificationContent({
    super.key,
    required this.email,
    required this.autoResend,
  });

  @override
  State<EmailVerificationContent> createState() =>
      _EmailVerificationContentState();
}

class _EmailVerificationContentState extends State<EmailVerificationContent> {
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
              padding: AppInsets.a24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSpacing.v16,
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 72,
                    color: colorScheme.primary,
                  ),
                  AppSpacing.v24,
                  Text(
                    'verification.title'.tr(),
                    style: AppTextStyles.headlineSm(
                      weight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ).copyWith(height: 1.33),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.v12,
                  Text(
                    'verification.message'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.v8,
                  Text(
                    widget.email,
                    style: AppTextStyles.bodyMedium(
                      weight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.v32,
                  AppTextField(
                    controller: _tokenController,
                    label: 'verification.token_label'.tr(),
                    prefixIcon: const Icon(Icons.verified_outlined),
                    keyboardType: TextInputType.text,
                  ),
                  AppSpacing.v24,
                  FilledButton(
                    onPressed: isLoading ? null : _onVerify,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.lightOnPrimary,
                              ),
                            ),
                          )
                        : Text('verification.verify'.tr()),
                  ),
                  AppSpacing.v12,
                  TextButton(
                    onPressed: isLoading ? null : _onResend,
                    child: Text('verification.resend'.tr()),
                  ),
                  AppSpacing.v12,
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
