import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';

class SocialLoginDialog extends StatefulWidget {
  final String provider;

  const SocialLoginDialog({
    super.key,required this.provider});

  @override
  State<SocialLoginDialog> createState() => _SocialLoginDialogState();
}

class _SocialLoginDialogState extends State<SocialLoginDialog> {
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
