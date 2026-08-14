import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/connectivity_cubit.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../features/checkout/presentation/widgets/payment_option.dart';
import '../../../../features/checkout/presentation/widgets/wallet_sheet.dart';
import '../cubit/payment_methods_cubit.dart';
import '../cubit/payment_methods_state.dart';
import '../widgets/add_card_form_sheet.dart';
import '../../../../core/widgets/saved_card_tile.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _storage = sl<LocalStorageService>();
  final _last4Ctrl = TextEditingController();
  final _monthCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  String _selected = '';
  String? _walletPhone;

  @override
  void initState() {
    super.initState();
    _walletPhone = _storage.getWalletPhone();
    _selected = _storage.getDefaultPaymentMethod() ?? '';
    context.read<PaymentMethodsCubit>().loadPaymentMethods();
  }

  @override
  void dispose() {
    _last4Ctrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectMethod(String method) async {
    setState(() => _selected = method);
    await _storage.setDefaultPaymentMethod(method);
  }

  Future<void> _showAddCardSheet() async {
    _last4Ctrl.clear();
    _monthCtrl.clear();
    _yearCtrl.clear();
    _nameCtrl.clear();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AddCardFormSheet(
        last4Ctrl: _last4Ctrl,
        monthCtrl: _monthCtrl,
        yearCtrl: _yearCtrl,
        nameCtrl: _nameCtrl,
        onSave: (last4, month, year, name, brand) {
          context.read<PaymentMethodsCubit>().addCard(
                number: last4,
                expiry: '$month/$year',
                cvv: '123',
                name: name,
              );
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _showWalletSheet() async {
    final result = await WalletSheet.show(context);
    if (result && mounted) {
      setState(() {
        _walletPhone = _storage.getWalletPhone();
      });
      _selectMethod('wallet');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
      listener: (context, state) {
        if (state is PaymentMethodsError) {
          AppSnackBar.show(context, state.message, type: SnackBarType.error);
        }
      },
      builder: (context, state) {
        final isLoading =
            state is PaymentMethodsLoading || state is PaymentMethodsInitial;
        final cards = context.read<PaymentMethodsCubit>().currentCards;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (_, connState) {
            if (connState is ConnectivityOnline) {
              context.read<PaymentMethodsCubit>().loadPaymentMethods();
            }
          },
          child: Scaffold(
            backgroundColor: cs.surface,
            body: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 24, 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'payment_methods.title'.tr(),
                    style: tt.headlineMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PaymentOption(
                    label: 'payment.mobile_wallet'.tr(),
                    subtitle: _walletPhone != null && _walletPhone!.isNotEmpty
                        ? _walletPhone!
                        : 'payment.tap_to_set_phone'.tr(),
                    icon: Icons.account_balance_wallet_outlined,
                    isSelected: _selected == 'wallet',
                    onTap: _showWalletSheet,
                  ),
                  const SizedBox(height: 12),
                  PaymentOption(
                    label: 'payment.apple_pay'.tr(),
                    subtitle: 'payment.apple_pay_subtitle'.tr(),
                    icon: Icons.apple,
                    isSelected: _selected == 'applepay',
                    onTap: () => _selectMethod('applepay'),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'payment_methods.saved_cards'.tr(),
                        style: tt.headlineMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showAddCardSheet,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text('payment_methods.add_card'.tr()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (cards.isEmpty)
                    Text(
                      'payment_methods.no_saved_cards'.tr(),
                      style: tt.bodySmall,
                    )
                  else
                    ...cards.map((c) {
                      final cardId = c['id'] as String? ?? '';
                      final last4 = c['card_last4'] as String? ?? '••••';
                      final month = c['expiry_month']?.toString() ?? '';
                      final year = c['expiry_year']?.toString() ?? '';
                      final isDef = c['is_default'] == true || _selected == cardId;

                      return SavedCardTile(
                        mask: '•••• $last4',
                        expiry: '$month/$year',
                        isDefault: isDef,
                        onTap: () => _selectMethod(cardId),
                        onDelete: () => context
                            .read<PaymentMethodsCubit>()
                            .deleteCard(cardId),
                      );
                    }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
