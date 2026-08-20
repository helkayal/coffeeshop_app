import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/cubit/shell_cubit.dart';
import '../../domain/entities/wallet_package.dart';
import 'cvc_prompt_dialog.dart';

class PackagePurchaseDialogs {
  const PackagePurchaseDialogs._();

  static void showApplePayConfirm(
    BuildContext context, {
    required WalletPackage package,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('checkout.apple_pay'.tr()),
        content: Text('wallet.confirm_payment'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text('wallet.confirm_payment'.tr()),
          ),
        ],
      ),
    );
  }

  static Future<void> showCvcPrompt(
    BuildContext context, {
    required String last4,
    required WalletPackage package,
    required VoidCallback onConfirm,
  }) async {
    // CvcPromptDialog owns its controller, so it outlives the dialog's
    // closing animation (disposing right after pop crashes the TextField).
    await showDialog<void>(
      context: context,
      builder: (_) => CvcPromptDialog(last4: last4, onConfirm: onConfirm),
    );
  }

  static void showMobileWalletConfirm(
    BuildContext context, {
    required String walletPhone,
    required WalletPackage package,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('wallet.payment_method'.tr()),
        content: Text(
          walletPhone.isNotEmpty
              ? 'wallet.mobile_wallet_confirm'.tr(args: [walletPhone])
              : 'wallet.mobile_wallet_generic'.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text('wallet.confirm_payment'.tr()),
          ),
        ],
      ),
    );
  }

  static void showNoPaymentMethodAlert(
    BuildContext context, {
    required ShellCubit shellCubit,
    required VoidCallback onCloseSheet,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('wallet.no_payment_method'.tr()),
        content: Text('wallet.no_payment_method_msg'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onCloseSheet();
              shellCubit.pushSecondary(const PaymentMethodsRoute());
            },
            child: Text('wallet.go_to_payment_methods'.tr()),
          ),
        ],
      ),
    );
  }
}
