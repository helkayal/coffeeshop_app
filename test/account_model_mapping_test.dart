import 'package:coffeeshop_app/features/account/data/models/payment_method_model.dart';
import 'package:coffeeshop_app/features/account/data/models/wallet_package_model.dart';
import 'package:coffeeshop_app/features/account/data/models/wallet_transaction_model.dart';
import 'package:coffeeshop_app/features/account/domain/entities/wallet_transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps wallet package and transaction JSON to domain values', () {
    final package = WalletPackageModel.fromJson({
      'id': 'package-1',
      'name': 'Starter',
      'amount': '100.00',
      'loyalty_points': 200,
    });
    final transaction = WalletTransactionModel.fromJson({
      'id': 'transaction-1',
      'amount': '25.50',
      'type': 'refund',
      'created_at': '2026-08-15T10:00:00Z',
    });

    expect(package.amount, 100);
    expect(transaction.amount, 25.5);
    expect(transaction.type, WalletTransactionType.refund);
  });

  test('rejects malformed wallet and payment data', () {
    expect(
      () => WalletPackageModel.fromJson({'id': '', 'amount': 'bad'}),
      throwsFormatException,
    );
    expect(
      () => WalletTransactionModel.fromJson({'id': 'transaction-1'}),
      throwsFormatException,
    );
    expect(
      () => PaymentMethodModel.fromJson({'id': 'card-1'}),
      throwsFormatException,
    );
  });
}
