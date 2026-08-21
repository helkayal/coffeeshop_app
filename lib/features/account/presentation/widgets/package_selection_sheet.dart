import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_insets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/purchase_method_decision.dart';
import '../../domain/entities/wallet_package.dart';
import '../cubit/payment_methods_cubit.dart';
import '../cubit/payment_preferences_cubit.dart';
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
  WalletPackage? _selectedPackage;

  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().loadPackages();
  }

  /// Picks the default package the first time packages load: the cheapest
  /// package covering [requiredAmount], falling back to the first package.
  void _onWalletState(WalletState state) {
    if (_selectedPackage != null) return;
    if (state is! PackagesLoaded || state.packages.isEmpty) return;
    final requiredAmount = widget.requiredAmount;
    setState(() {
      _selectedPackage =
          requiredAmount != null && requiredAmount > 0
          ? state.packages.firstWhere(
              (package) => package.amount >= requiredAmount,
              orElse: () => state.packages.first,
            )
          : state.packages.first;
    });
  }

  Future<void> _onBuyPressed() async {
    final pkg = _selectedPackage;
    if (pkg == null) return;

    final paymentCubit = context.read<PaymentMethodsCubit>();
    await paymentCubit.loadPaymentMethods();
    if (!mounted) return;
    final decision = context
        .read<PaymentPreferencesCubit>()
        .decidePurchaseMethod(cards: paymentCubit.currentCards);

    switch (decision) {
      case UseWalletDecision(:final walletPhone):
        PackagePurchaseDialogs.showMobileWalletConfirm(
          context,
          walletPhone: walletPhone,
          package: pkg,
          onConfirm: () => _executeBuy(pkg),
        );
      case UseApplePayDecision():
        PackagePurchaseDialogs.showApplePayConfirm(
          context,
          package: pkg,
          onConfirm: () => _executeBuy(pkg),
        );
      case UseCardDecision(:final card):
        PackagePurchaseDialogs.showCvcPrompt(
          context,
          last4: card.lastFour,
          package: pkg,
          onConfirm: () => _executeBuy(pkg),
        );
      case NoPaymentMethodDecision():
        PackagePurchaseDialogs.showNoPaymentMethodAlert(
          context,
          shellCubit: context.read<ShellCubit>(),
          onCloseSheet: () => Navigator.pop(context),
        );
    }
  }

  Future<void> _executeBuy(WalletPackage pkg) async {
    final walletCubit = context.read<WalletCubit>();
    await walletCubit.buyPackage(pkg.id);
    if (!mounted) return;
    final state = walletCubit.state;
    if (state is PackagePurchased) {
      context.read<ProfileCubit>().loadProfile();
      AppSnackBar.show(
        context,
        'wallet.package_purchase_success'.tr(),
        type: SnackBarType.success,
      );
      Navigator.pop(context, state.newBalance ?? true);
    }
    // Purchase failures surface via PackagesError in the builder.
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocConsumer<WalletCubit, WalletState>(
      listener: (_, state) => _onWalletState(state),
      builder: (context, state) {
        final packages = switch (state) {
          PackagesLoaded(:final packages) => packages,
          PackagesBuyInProgress(:final packages) => packages,
          PackagesError(packages: final packages?) => packages,
          _ => const <WalletPackage>[],
        };
        final showList = state is PackagesLoaded ||
            state is PackagesBuyInProgress ||
            state is PackagesError && state.packages != null;
        final loading =
            state is! PackagesLoaded &&
            state is! PackagesError &&
            state is! PackagesBuyInProgress;
        final purchasing = state is PackagesBuyInProgress;
        final error = state is PackagesError ? state.message : null;

        return Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32),
            ),
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
                style: AppTextStyles.headlineSm(
                  weight: FontWeight.bold,
                  color: cs.onSurface,
                ).copyWith(height: 1.3),
              ),
              AppSpacing.v8,
              Text(
                'wallet.package_subtitle'.tr(),
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              AppSpacing.v24,
              if (loading)
                const Center(
                  child: Padding(
                    padding: AppInsets.a32,
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (!showList && error != null)
                Center(
                  child: Padding(
                    padding: AppInsets.a16,
                    child: Text(
                      error.tr(),
                      style: AppTextStyles.bodyMedium(color: cs.error),
                    ),
                  ),
                )
              else ...[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: packages.length,
                    separatorBuilder: (_, index) => AppSpacing.v12,
                    itemBuilder: (context, index) {
                      final pkg = packages[index];
                      final isSelected = _selectedPackage?.id == pkg.id;
                      return WalletPackageTile(
                        package: pkg,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedPackage = pkg),
                      );
                    },
                  ),
                ),
                if (error != null) ...[
                  AppSpacing.v12,
                  Text(
                    error.tr(),
                    style: AppTextStyles.captionSm(color: cs.error),
                  ),
                ],
                AppSpacing.v24,
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: purchasing ? null : _onBuyPressed,
                    style: FilledButton.styleFrom(
                      padding: AppInsets.v16,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: purchasing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.lightOnPrimary,
                            ),
                          )
                        : Text(
                            'wallet.buy_package'.tr(),
                            style: AppTextStyles.bodyLarge(
                              weight: FontWeight.bold,
                              color: cs.onPrimary,
                            ),
                          ),
                  ),
                ),
              ],
              AppSpacing.v16,
            ],
          ),
        );
      },
    );
  }
}
