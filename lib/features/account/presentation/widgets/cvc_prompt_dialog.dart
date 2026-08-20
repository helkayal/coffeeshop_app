import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';

class CvcPromptDialog extends StatefulWidget {
  final String last4;
  final VoidCallback onConfirm;

  const CvcPromptDialog({
    super.key,
    required this.last4,
    required this.onConfirm,
  });

  @override
  State<CvcPromptDialog> createState() => _CvcPromptDialogState();
}

class _CvcPromptDialogState extends State<CvcPromptDialog> {
  final _cvcCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _cvcCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    final cvc = _cvcCtrl.text.trim();
    if (cvc.length < 3 || cvc.length > 4 || int.tryParse(cvc) == null) {
      setState(() => _error = 'wallet.cvc_required'.tr());
      return;
    }
    Navigator.pop(context);
    widget.onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'wallet.confirm_credit_card'.tr(args: [widget.last4]),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _cvcCtrl,
            hintText: 'wallet.enter_cvc'.tr(),
            keyboardType: TextInputType.number,
            isPassword: true,
            errorText: _error,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr()),
        ),
        FilledButton(
          onPressed: _confirm,
          child: Text('wallet.confirm_payment'.tr()),
        ),
      ],
    );
  }
}
