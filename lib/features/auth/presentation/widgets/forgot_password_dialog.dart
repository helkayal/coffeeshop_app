import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';

// ---------------------------------------------------------------------------
// Private dialog widgets — each owns its own TextEditingControllers.
//
// Flutter calls State.dispose() AFTER the pop animation fully completes,
// so the controllers are guaranteed alive during the entire close animation.
// This eliminates the race between the animation rebuild and controller
// disposal that caused the "controller used after dispose" assertion.
// ---------------------------------------------------------------------------

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
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
