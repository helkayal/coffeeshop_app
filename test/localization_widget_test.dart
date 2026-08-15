import 'dart:convert';
import 'dart:io';

import 'package:coffeeshop_app/features/account/domain/entities/wallet_package.dart';
import 'package:coffeeshop_app/features/account/presentation/widgets/wallet_package_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final testCase in [
    (locale: const Locale('en'), price: '100 EGP'),
    (locale: const Locale('ar'), price: '100 ج.م'),
  ]) {
    testWidgets('wallet package localizes price in ${testCase.locale}', (
      tester,
    ) async {
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          startLocale: testCase.locale,
          fallbackLocale: const Locale('en'),
          assetLoader: const _FileAssetLoader(),
          child: Builder(
            builder: (context) => MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: Scaffold(
                body: WalletPackageTile(
                  package: const WalletPackage(
                    id: 'package-1',
                    name: 'Starter',
                    amount: 100,
                    loyaltyPoints: 200,
                  ),
                  isSelected: true,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(testCase.price), findsOneWidget);
    });
  }
}

class _FileAssetLoader extends AssetLoader {
  const _FileAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final file = File(
      '$path/${locale.toStringWithSeparator(separator: '-')}.json',
    );
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}
