import 'package:coffeeshop_app/features/account/presentation/widgets/package_purchase_dialogs.dart';
import 'package:coffeeshop_app/features/account/presentation/widgets/wallet_package_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../data/models/wallet_package_model.dart';
import '../../domain/usecases/payment_methods_usecases.dart';
import '../../domain/usecases/wallet_usecases.dart';
import '../cubit/profile_cubit.dart';

class PackageSelectionSheet extends StatefulWidget {
  final double? requiredAmount;

  const PackageSelectionSheet({
    super.key,
    this.requiredAmount,
  });

  static Future<dynamic> show(
    BuildContext context, {
    double? requiredAmount,
  }) async {
    return showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PackageSelectionSheet(requiredAmount: requiredAmount),
    );
  }

  @override
  State<PackageSelectionSheet> createState() => _PackageSelectionSheetState();
}

class _PackageSelectionSheetState extends State<PackageSelectionSheet> {
  final _getPackages = sl<GetWalletPackagesUseCase>();
  final _buyPackage = sl<BuyWalletPackageUseCase>();
  final _getPaymentMethods = sl<GetPaymentMethodsUseCase>();
  final _storage = sl<LocalStorageService>();

  List<WalletPackage> _packages = [];
  WalletPackage? _selectedPackage;
  bool _loading = true;
  bool _purchasing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    final result = await _getPackages();
    if (!mounted) return;
    result.fold(
      (failure) {
        setState(() {
          _loading = false;
          _error = failure.message;
        });
      },
      (list) {
        setState(() {
          _packages = list;
          if (list.isNotEmpty) {
            if (widget.requiredAmount != null && widget.requiredAmount! > 0) {
              _selectedPackage = list.firstWhere(
                (p) => p.amount >= widget.requiredAmount!,
                orElse: () => list.first,
              );
            } else {
              _selectedPackage = list.first;
            }
          }
          _loading = false;
        });
      },
    );
  }

  Future<void> _onBuyPressed() async {
    final pkg = _selectedPackage;
    if (pkg == null) return;

    setState(() {
      _purchasing = true;
      _error = null;
    });

    List<Map<String, dynamic>> cards = [];
    final pmResult = await _getPaymentMethods();
    pmResult.fold((_) => cards = [], (list) => cards = list);

    final walletPhone = _storage.getWalletPhone();

    if (!mounted) return;
    setState(() => _purchasing = false);

    final defaultMethod = _storage.getDefaultPaymentMethod();

    if (defaultMethod == 'wallet' || (cards.isEmpty && walletPhone != null && walletPhone.trim().isNotEmpty)) {
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
        (c) => c['id'] == defaultMethod || c['is_default'] == true,
        orElse: () => cards.first,
      );
      final last4 = defaultCard['card_last4'] as String? ?? '••••';
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

    final result = await _buyPackage(pkg.id);
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _purchasing = false;
          _error = failure.message;
        });
      },
      (newBalance) {
        try {
          context.read<ProfileCubit>().loadProfile();
        } catch (_) {}

        AppSnackBar.show(
          context,
          'Package purchased successfully!',
          type: SnackBarType.success,
        );
        Navigator.pop(context, newBalance ?? true);
      },
    );
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
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
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
          const SizedBox(height: 24),
          Text(
            'wallet.select_package'.tr(),
            style: tt.headlineMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'wallet.package_subtitle'.tr(),
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_error != null && _packages.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!, style: TextStyle(color: cs.error)),
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
                separatorBuilder: (_, index) => const SizedBox(height: 12),
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
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: cs.error, fontSize: 13)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _purchasing ? null : _onBuyPressed,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
