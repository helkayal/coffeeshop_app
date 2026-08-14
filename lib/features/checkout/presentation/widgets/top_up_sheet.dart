import 'package:flutter/material.dart';

import '../../../../core/services/service_locator.dart';
import '../../../account/domain/usecases/wallet_usecases.dart';
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
    final result = await PackageSelectionSheet.show(
      context,
      requiredAmount: requiredAmount,
    );

    if (result is double) {
      return result;
    }
    if (result == true) {
      final getBalance = sl<GetWalletBalanceUseCase>();
      final balanceResult = await getBalance();
      return balanceResult.fold((_) => null, (bal) => bal);
    }
    return null;
  }
}
