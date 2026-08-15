import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../account/presentation/cubit/wallet_cubit.dart';
import '../../../account/presentation/cubit/wallet_state.dart';
import '../../../account/presentation/widgets/package_selection_sheet.dart';

class TopUpSheet {
  const TopUpSheet._();

  /// Shows the package purchase sheet during checkout when wallet balance is insufficient.
  /// Returns the new wallet balance if the package purchase succeeded, or null.
  static Future<double?> show(
    BuildContext context, {
    required double requiredAmount,
    required VoidCallback onAddPaymentMethod,
  }) async {
    final walletCubit = context.read<WalletCubit>();
    final result = await PackageSelectionSheet.show(
      context,
      requiredAmount: requiredAmount,
    );

    if (result is double) {
      return result;
    }
    if (result == true) {
      await walletCubit.loadBalance();
      return switch (walletCubit.state) {
        WalletBalanceLoaded(:final balance) => balance,
        _ => null,
      };
    }
    return null;
  }
}
