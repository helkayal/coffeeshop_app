import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/password_validator.dart';
import '../../../../core/helpers/result.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Reset-password dialog shown after the forgot-password request.
///
/// Validates the new password and its confirmation with the same
/// [PasswordValidator] rules as register, then submits via [onSubmit].
/// On a backend rejection the dialog stays open and shows the error inline
/// so the user can re-enter the password.
class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({
    super.key,
    required this.token,
    required this.email,
    required this.onSubmit,
  });

  final String token;
  final String email;
  final Future<Result<void>> Function(String newPassword) onSubmit;

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _passwordError;
  String? _confirmPasswordError;
  String? _submitError;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _tokenController.text = widget.token;
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  // Live re-validate only after a submit attempt has shown an error, so the
  // user doesn't see errors while typing from scratch.
  void _onPasswordChanged() {
    if (_passwordError == null && _submitError == null) return;
    setState(() {
      _passwordError = _passwordError == null
          ? null
          : PasswordValidator.validate(
              _passwordController.text,
              email: widget.email,
            )?.tr();
      _submitError = null;
    });
    if (_confirmPasswordController.text.isNotEmpty) _onConfirmPasswordChanged();
  }

  void _onConfirmPasswordChanged() {
    final text = _confirmPasswordController.text;
    if (_confirmPasswordError == null && _submitError == null && text.isEmpty) {
      return;
    }
    setState(() {
      _confirmPasswordError = _confirmPasswordError == null
          ? null
          : PasswordValidator.validateConfirm(
              _passwordController.text,
              text,
            )?.tr();
      _submitError = null;
    });
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onResetPressed() async {
    final password = _passwordController.text;
    final passwordError =
        PasswordValidator.validate(password, email: widget.email);
    final confirmError = PasswordValidator.validateConfirm(
      password,
      _confirmPasswordController.text,
    );
    if (passwordError != null || confirmError != null) {
      setState(() {
        _passwordError = passwordError?.tr();
        _confirmPasswordError = confirmError?.tr();
      });
      return;
    }

    setState(() => _submitting = true);
    final result = await widget.onSubmit(password);
    if (!mounted) return;
    setState(() => _submitting = false);

    result.fold(
      (failure) => setState(() => _submitError = failure.message),
      (_) => Navigator.pop(context, password),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text('verification.reset_password'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('verification.reset_token_msg'.tr()),
          const SizedBox(height: 12),
          AppTextField(
            label: 'verification.reset_token_label'.tr(),
            controller: _tokenController,
            prefixIcon: const Icon(Icons.key),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _passwordController,
            label: 'verification.new_password'.tr(),
            isPassword: true,
            prefixIcon: const Icon(Icons.lock_outlined),
            errorText: _passwordError,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _confirmPasswordController,
            label: 'auth.confirm_password'.tr(),
            isPassword: true,
            prefixIcon: const Icon(Icons.lock_outlined),
            errorText: _confirmPasswordError,
          ),
          if (_submitError != null) ...[
            const SizedBox(height: 12),
            Text(
              _submitError!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        FilledButton(
          onPressed: _submitting ? null : _onResetPressed,
          child: Text('verification.reset'.tr()),
        ),
      ],
    );
  }
}
