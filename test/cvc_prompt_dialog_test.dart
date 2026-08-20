import 'dart:convert';
import 'dart:io';

import 'package:coffeeshop_app/features/account/domain/entities/wallet_package.dart';
import 'package:coffeeshop_app/features/account/presentation/widgets/package_purchase_dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reads translation JSONs synchronously so they load inside the widget
/// test's fake-async zone, where rootBundle asset loading hangs.
class _FileAssetLoader extends AssetLoader {
  const _FileAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final file = File(
      '$path/${locale.toStringWithSeparator(separator: '-')}.json',
    );
    return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}

void main() {
  Future<void> pumpHost(
    WidgetTester tester, {
    required VoidCallback onConfirm,
  }) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        startLocale: const Locale('en'),
        fallbackLocale: const Locale('en'),
        assetLoader: const _FileAssetLoader(),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => PackagePurchaseDialogs.showCvcPrompt(
                      context,
                      last4: '4242',
                      package: const WalletPackage(
                        id: 'p1',
                        name: 'Starter',
                        amount: 100,
                        loyaltyPoints: 100,
                      ),
                      onConfirm: onConfirm,
                    ),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('confirming with a valid CVC closes without exceptions', (
    tester,
  ) async {
    var confirmed = false;
    await pumpHost(tester, onConfirm: () => confirmed = true);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.enterText(find.byType(TextField), '123');
    await tester.tap(find.text('Confirm Payment'));
    // Let the closing animation finish: the controller must stay alive for
    // the TextField while the dialog route animates out.
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(confirmed, isTrue);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('invalid CVC shows the error and keeps the dialog open', (
    tester,
  ) async {
    var confirmed = false;
    await pumpHost(tester, onConfirm: () => confirmed = true);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '12');
    await tester.tap(find.text('Confirm Payment'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid CVC (3-4 digits)'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(confirmed, isFalse);
  });
}
