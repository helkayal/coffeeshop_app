import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/cubit/shell_cubit.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../data/models/wallet_package_model.dart';
import '../cubit/profile_cubit.dart';
import 'package:coffeeshop_app/features/account/presentation/widgets/package_purchase_dialogs.dart';
import 'package:coffeeshop_app/features/account/presentation/widgets/wallet_package_tile.dart';

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
  final _api = sl<ApiService>();
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
    try {
      final data = await _api.get(ApiConstants.walletPackages);
      if (!mounted) return;

      List<WalletPackage> list = [];
      if (data is List) {
        list = data.map((e) => WalletPackage.fromJson(e as Map<String, dynamic>)).toList();
      } else if (data is Map<String, dynamic> && data['data'] is List) {
        list = (data['data'] as List)
            .map((e) => WalletPackage.fromJson(e as Map<String, dynamic>))
            .toList();
      }

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
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'credit_card.load_error'.tr();
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

    List<Map<String, dynamic>> cards = [];
    try {
      final data = await _api.get(ApiConstants.paymentMethods);
      cards = data is List ? List<Map<String, dynamic>>.from(data) : <Map<String, dynamic>>[];
    } catch (_) {
      cards = [];
    }

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

    try {
      final res = await _api.post(
        ApiConstants.walletPackagesBuy,
        data: {'package_id': pkg.id},
      );

      try {
        if (mounted) {
          context.read<ProfileCubit>().loadProfile();
        }
      } catch (_) {}

      double? newBalance;
      if (res is Map<String, dynamic>) {
        final dataMap = (res['data'] as Map<String, dynamic>?) ?? res;
        final rawBal = dataMap['coffee_cash'] ?? dataMap['balance'];
        if (rawBal != null) {
          newBalance = rawBal is num
              ? rawBal.toDouble()
              : double.tryParse(rawBal.toString());
        }
      }

      if (mounted) {
        AppSnackBar.show(
          context,
          'Package purchased successfully!',
          type: SnackBarType.success,
        );
        Navigator.pop(context, newBalance ?? true);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _purchasing = false;
        _error = 'Purchase failed. Please try again.';
      });
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
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.stars, color: cs.primary, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'wallet.buy_packages'.tr(),
                  style: tt.headlineMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'wallet.earn_2x_loyalty'.tr(),
            style: tt.bodySmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null && _packages.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Text(_error!, style: tt.bodyMedium?.copyWith(color: cs.error)),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _loadPackages,
                      child: Text('credit_card.retry'.tr()),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _packages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
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
              Text(
                _error!,
                style: tt.bodySmall?.copyWith(color: cs.error),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (_purchasing || _selectedPackage == null)
                    ? null
                    : _onBuyPressed,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _purchasing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _selectedPackage != null
                            ? 'wallet.buy_package_button'.tr(args: [
                                _selectedPackage!.name,
                                _selectedPackage!.amount.toStringAsFixed(0)
                              ])
                            : 'wallet.select_package'.tr(),
                        style: tt.labelLarge?.copyWith(color: cs.onPrimary),
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
