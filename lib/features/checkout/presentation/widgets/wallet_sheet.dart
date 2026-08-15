import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../../../account/presentation/cubit/payment_preferences_cubit.dart';
import '../../../account/presentation/cubit/payment_preferences_state.dart';

class WalletSheet extends StatefulWidget {
  const WalletSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const WalletSheet(),
    );
    return result ?? false;
  }

  @override
  State<WalletSheet> createState() => _WalletSheetState();
}

class _WalletSheetState extends State<WalletSheet> {
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<PaymentPreferencesCubit>().state;
    if (state is PaymentPreferencesLoaded) {
      _phoneCtrl.text = state.preferences.walletPhone ?? '';
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isNotEmpty) {
      final saved = await context
          .read<PaymentPreferencesCubit>()
          .saveWalletPhone(phone);
      if (!saved || !mounted) return;
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
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
      padding: EdgeInsetsDirectional.fromSTEB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
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
          const SizedBox(height: 24),
          Text(
            'wallet.phone_for_wallet'.tr(),
            style: tt.headlineMedium?.copyWith(
              fontSize: 24,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          AppTextField(
            controller: _phoneCtrl,
            label: 'wallet.phone_number'.tr(),
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_android),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              child: Text('wallet.continue'.tr()),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
