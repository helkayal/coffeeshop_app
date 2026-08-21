import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/card_validator.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';

class AddCardFormSheet extends StatefulWidget {
  final TextEditingController last4Ctrl;
  final TextEditingController monthCtrl;
  final TextEditingController yearCtrl;
  final TextEditingController nameCtrl;
  final void Function(
    String last4,
    String month,
    String year,
    String name,
    String brand,
  )
  onSave;

  const AddCardFormSheet({
    super.key,
    required this.last4Ctrl,
    required this.monthCtrl,
    required this.yearCtrl,
    required this.nameCtrl,
    required this.onSave,
  });

  @override
  State<AddCardFormSheet> createState() => _AddCardFormSheetState();
}

class _AddCardFormSheetState extends State<AddCardFormSheet> {
  String? _error;

  String? _validate() {
    final numberError = CardValidator.validateNumber(widget.last4Ctrl.text);
    if (numberError != null) return numberError;

    final nameError = CardValidator.validateName(widget.nameCtrl.text);
    if (nameError != null) return nameError;

    final month = int.tryParse(widget.monthCtrl.text.trim());
    if (month == null || month < 1 || month > 12) {
      return 'credit_card.invalid_month';
    }

    final year = int.tryParse(widget.yearCtrl.text.trim());
    if (year == null) {
      return 'credit_card.year_required';
    }

    if (CardValidator.isExpired(month, year)) {
      return 'credit_card.expired';
    }

    return null;
  }

  void _submit() {
    final error = _validate();
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    final number = widget.last4Ctrl.text.trim().replaceAll(RegExp(r'\s+'), '');
    final last4 = number.substring(number.length - 4);
    var year = int.parse(widget.yearCtrl.text.trim());
    if (year < 100) year += 2000;

    final brand = CardValidator.detectBrand(number);

    widget.onSave(
      last4,
      widget.monthCtrl.text.trim(),
      year.toString(),
      widget.nameCtrl.text.trim(),
      brand,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: AppInsets.bottomSheetWithKeyboard(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant.withAlpha(128),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          AppSpacing.v24,
          Text(
            'credit_card.add_new_card'.tr(),
            style: AppTextStyles.subtitle(color: cs.onSurface)
                .copyWith(height: 1.3),
          ),
          AppSpacing.v16,
          AppTextField(
            controller: widget.last4Ctrl,
            label: 'credit_card.card_number'.tr(),
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.credit_card),
          ),
          AppSpacing.v12,
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: widget.monthCtrl,
                  label: 'credit_card.month'.tr(),
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: AppTextField(
                  controller: widget.yearCtrl,
                  label: 'credit_card.year'.tr(),
                ),
              ),
            ],
          ),
          AppSpacing.v12,
          AppTextField(
            controller: widget.nameCtrl,
            label: 'credit_card.name_on_card'.tr(),
            prefixIcon: const Icon(Icons.person_outline),
          ),
          if (_error case final error?) ...[
            AppSpacing.v8,
            Text(error.tr(), style: tt.bodySmall?.copyWith(color: cs.error)),
          ],
          AppSpacing.v24,
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: Text('credit_card.save_card'.tr()),
            ),
          ),
          AppSpacing.v16,
        ],
      ),
    );
  }
}
