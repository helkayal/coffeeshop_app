import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/service_locator.dart';
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
      try {
        final api = sl<ApiService>();
        final data = await api.get(ApiConstants.wallet);
        final rawBal = data['coffee_cash'] ?? data['balance'];
        if (rawBal != null) {
          return rawBal is num
              ? rawBal.toDouble()
              : double.tryParse(rawBal.toString());
        }
      } catch (_) {}
    }
    return null;
  }
}
