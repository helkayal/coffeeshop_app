import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/saved_card_tile.dart';
import '../../../account/presentation/cubit/payment_methods_cubit.dart';
import '../../../account/presentation/cubit/payment_methods_state.dart';
import '../../../account/presentation/cubit/payment_preferences_cubit.dart';

class CreditCardSheet extends StatefulWidget {
  const CreditCardSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final paymentMethodsCubit = context.read<PaymentMethodsCubit>();
    final paymentPreferencesCubit = context.read<PaymentPreferencesCubit>();

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: paymentMethodsCubit),
          BlocProvider.value(value: paymentPreferencesCubit),
        ],
        child: const CreditCardSheet(),
      ),
    );
    return result ?? false;
  }

  @override
  State<CreditCardSheet> createState() => _CreditCardSheetState();
}

class _CreditCardSheetState extends State<CreditCardSheet> {
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String? _formError;

  @override
  void initState() {
    super.initState();
    context.read<PaymentMethodsCubit>().loadPaymentMethods();
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  (int, int)? _parseExpiry() {
    final text = _expiryCtrl.text.trim();
    if (text.isEmpty) return null;

    int month, year;
    if (text.contains('/')) {
      final parts = text.split('/');
      month = int.tryParse(parts[0].trim()) ?? 0;
      year = int.tryParse(parts[1].trim()) ?? 0;
    } else if (text.length == 4) {
      month = int.tryParse(text.substring(0, 2)) ?? 0;
      year = int.tryParse(text.substring(2)) ?? 0;
    } else {
      return null;
    }

    if (year < 100) year += 2000;
    if (month < 1 || month > 12 || year < 2000) return null;
    return (month, year);
  }

  String? _validate() {
    final number = _numberCtrl.text.trim().replaceAll(RegExp(r'\s+'), '');
    if (number.length != 16 || int.tryParse(number) == null) {
      return 'credit_card.invalid_number';
    }
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return 'credit_card.name_required';

    final expiry = _parseExpiry();
    if (expiry == null) return 'credit_card.invalid_expiry';

    final (month, year) = expiry;
    if (month < 1 || month > 12) return 'credit_card.invalid_month';

    final now = DateTime.now();
    final expiryDate = DateTime(year, month + 1, 0);
    final currentMonthEnd = DateTime(now.year, now.month + 1, 0);
    if (expiryDate.isBefore(currentMonthEnd)) return 'credit_card.expired';

    return null;
  }

  Future<void> _saveCard() async {
    setState(() => _formError = null);
    final error = _validate();
    if (error != null) {
      setState(() => _formError = error);
      return;
    }

    final number = _numberCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final expiryText = _expiryCtrl.text.trim();
    final cvvText = _cvvCtrl.text.trim();

    await context.read<PaymentMethodsCubit>().addCard(
      number: number,
      expiry: expiryText,
      cvv: cvvText,
      name: name,
    );

    _numberCtrl.clear();
    _expiryCtrl.clear();
    _cvvCtrl.clear();
    _nameCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: AppInsets.bottomSheetWithKeyboard(context),
      child: BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
        builder: (context, state) {
          final isLoading = state is PaymentMethodsLoading;
          final cards = context.read<PaymentMethodsCubit>().currentCards;

          return SingleChildScrollView(
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
                  'credit_card.select_card'.tr(),
                  style: tt.headlineMedium?.copyWith(
                    fontSize: 24,
                    color: cs.onSurface,
                  ),
                ),
                AppSpacing.v16,
                if (isLoading)
                  const CircularProgressIndicator()
                else if (cards.isNotEmpty) ...[
                  ...cards.map((card) {
                    return SavedCardTile(
                      mask: '•••• ${card.lastFour}',
                      expiry: '${card.expiryMonth}/${card.expiryYear}',
                      isDefault: card.isDefault,
                      onTap: () {
                        context.read<PaymentPreferencesCubit>().selectMethod(
                          card.id,
                        );
                        Navigator.pop(context, true);
                      },
                      onDelete: () => context
                          .read<PaymentMethodsCubit>()
                          .deleteCard(card.id),
                    );
                  }),
                  const Divider(height: 32),
                ],
                Text(
                  'credit_card.title'.tr(),
                  style: tt.headlineMedium?.copyWith(
                    fontSize: 20,
                    color: cs.onSurface,
                  ),
                ),
                AppSpacing.v16,
                AppTextField(
                  controller: _numberCtrl,
                  label: 'credit_card.number'.tr(),
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.credit_card),
                ),
                AppSpacing.v12,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _expiryCtrl,
                        label: 'credit_card.expiry'.tr(),
                        keyboardType: TextInputType.datetime,
                        hintText: 'credit_card.expiry_hint'.tr(),
                      ),
                    ),
                    AppSpacing.h12,
                    Expanded(
                      child: AppTextField(
                        controller: _cvvCtrl,
                        label: 'credit_card.cvv'.tr(),
                        keyboardType: TextInputType.number,
                        isPassword: true,
                      ),
                    ),
                  ],
                ),
                AppSpacing.v12,
                AppTextField(
                  controller: _nameCtrl,
                  label: 'credit_card.name'.tr(),
                  keyboardType: TextInputType.name,
                ),
                if (_formError case final error?) ...[
                  AppSpacing.v12,
                  Text(
                    error.tr(),
                    style: TextStyle(color: cs.error, fontSize: 13),
                  ),
                ],
                AppSpacing.v24,
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saveCard,
                    child: Text('credit_card.save'.tr()),
                  ),
                ),
                AppSpacing.v16,
              ],
            ),
          );
        },
      ),
    );
  }
}
