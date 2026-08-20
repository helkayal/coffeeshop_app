import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/wallet_package.dart';
import '../cubit/payment_methods_cubit.dart';
import '../cubit/payment_preferences_cubit.dart';
import '../cubit/payment_preferences_state.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/wallet_cubit.dart';
import '../cubit/wallet_state.dart';
import 'package_purchase_dialogs.dart';
import 'wallet_package_tile.dart';

class PackageSelectionSheet extends StatefulWidget {
  final double? requiredAmount;

  const PackageSelectionSheet({super.key, this.requiredAmount});

  static Future<dynamic> show(
    BuildContext context, {
    double? requiredAmount,
  }) async {
    final walletCubit = context.read<WalletCubit>();
    final paymentMethodsCubit = context.read<PaymentMethodsCubit>();
    final paymentPreferencesCubit = context.read<PaymentPreferencesCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final shellCubit = context.read<ShellCubit>();

    return showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: walletCubit),
          BlocProvider.value(value: paymentMethodsCubit),
          BlocProvider.value(value: paymentPreferencesCubit),
          BlocProvider.value(value: profileCubit),
          BlocProvider.value(value: shellCubit),
        ],
        child: PackageSelectionSheet(requiredAmount: requiredAmount),
      ),
    );
  }

  @override
  State<PackageSelectionSheet> createState() => _PackageSelectionSheetState();
}

class _PackageSelectionSheetState extends State<PackageSelectionSheet> {
  List<WalletPackage> _packages = [];
  WalletPackage? _selectedPackage;
  bool _loading = true;
  bool _purchasing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().loadPackages();
  }

  void _onWalletState(WalletState state) {
    if (state is PackagesLoaded) {
      final requiredAmount = widget.requiredAmount;
      setState(() {
        _packages = state.packages;
        _selectedPackage = state.packages.isEmpty
            ? null
            : requiredAmount != null && requiredAmount > 0
            ? state.packages.firstWhere(
                (package) => package.amount >= requiredAmount,
                orElse: () => state.packages.first,
              )
            : state.packages.first;
        _loading = false;
      });
    } else if (state is PackagesError) {
      setState(() {
        _loading = false;
        _purchasing = false;
        _error = state.message;
      });
    }
  }

  Future<void> _onBuyPressed() async {
    final pkg = _selectedPackage;
    if (pkg == null) return;

    setState(() {
      _purchasing = true;
      _error = null;
    });

    final paymentCubit = context.read<PaymentMethodsCubit>();
    final preferenceCubit = context.read<PaymentPreferencesCubit>();
    await paymentCubit.loadPaymentMethods();
    final List<PaymentMethod> cards = paymentCubit.currentCards;
    final preferenceState = preferenceCubit.state;
    final preferences = preferenceState is PaymentPreferencesLoaded
        ? preferenceState.preferences
        : null;
    final walletPhone = preferences?.walletPhone;

    if (!mounted) return;
    setState(() => _purchasing = false);

    final defaultMethod = preferences?.defaultMethod;

    if (defaultMethod == 'wallet' ||
        (cards.isEmpty &&
            walletPhone != null &&
            walletPhone.trim().isNotEmpty)) {
      PackagePurchaseDialogs.showMobileWalletConfirm(
        context,
        walletPhone: walletPhone?.trim() ?? '',
        package: pkg,
        onConfirm: () => _executeBuy(pkg),
      );
    } else if (defaultMethod == 'applepay') {
      PackagePurchaseDialogs.showApplePayConfirm(
        context,
        package: pkg,
        onConfirm: () => _executeBuy(pkg),
      );
    } else if (cards.isNotEmpty) {
      final defaultCard = cards.firstWhere(
        (card) => card.id == defaultMethod || card.isDefault,
        orElse: () => cards.first,
      );
      final last4 = defaultCard.lastFour;
      PackagePurchaseDialogs.showCvcPrompt(
        context,
        last4: last4,
        package: pkg,
        onConfirm: () => _executeBuy(pkg),
      );
    } else if (walletPhone != null && walletPhone.trim().isNotEmpty) {
      PackagePurchaseDialogs.showMobileWalletConfirm(
        context,
        walletPhone: walletPhone.trim(),
        package: pkg,
        onConfirm: () => _executeBuy(pkg),
      );
    } else {
      PackagePurchaseDialogs.showNoPaymentMethodAlert(
        context,
        shellCubit: context.read<ShellCubit>(),
        onCloseSheet: () => Navigator.pop(context),
      );
    }
  }

  Future<void> _executeBuy(WalletPackage pkg) async {
    setState(() {
      _purchasing = true;
      _error = null;
    });

    final walletCubit = context.read<WalletCubit>();
    await walletCubit.buyPackage(pkg.id);
    if (!mounted) return;
    final state = walletCubit.state;
    if (state is PackagesError) {
      setState(() {
        _purchasing = false;
        _error = state.message;
      });
      return;
    }
    if (state is PackagePurchased) {
      context.read<ProfileCubit>().loadProfile();
      AppSnackBar.show(
        context,
        'wallet.package_purchase_success'.tr(),
        type: SnackBarType.success,
      );
      Navigator.pop(context, state.newBalance ?? true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocListener<WalletCubit, WalletState>(
      listener: (_, state) => _onWalletState(state),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.s24,
          AppSpacing.s24,
          AppSpacing.s24,
          AppSpacing.s24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant.withAlpha(128),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            AppSpacing.v24,
            Text(
              'wallet.select_package'.tr(),
              style: tt.headlineMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            AppSpacing.v8,
            Text(
              'wallet.package_subtitle'.tr(),
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            AppSpacing.v24,
            if (_loading)
              const Center(
                child: Padding(
                  padding: AppInsets.a32,
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error case final error? when _packages.isEmpty)
              Center(
                child: Padding(
                  padding: AppInsets.a16,
                  child: Text(error, style: TextStyle(color: cs.error)),
                ),
              )
            else ...[
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _packages.length,
                  separatorBuilder: (_, index) => AppSpacing.v12,
                  itemBuilder: (context, index) {
                    final pkg = _packages[index];
                    final isSelected = _selectedPackage?.id == pkg.id;
                    return WalletPackageTile(
                      package: pkg,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedPackage = pkg),
                    );
                  },
                ),
              ),
              if (_error case final error?) ...[
                AppSpacing.v12,
                Text(error, style: TextStyle(color: cs.error, fontSize: 13)),
              ],
              AppSpacing.v24,
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _purchasing ? null : _onBuyPressed,
                  style: FilledButton.styleFrom(
                    padding: AppInsets.v16,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _purchasing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'wallet.buy_package'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
            AppSpacing.v16,
          ],
        ),
      ),
    );
  }
}
