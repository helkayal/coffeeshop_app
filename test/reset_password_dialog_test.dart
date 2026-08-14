import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffeeshop_app/core/errors/failures.dart';
import 'package:coffeeshop_app/core/helpers/result.dart';
import 'package:coffeeshop_app/features/auth/presentation/widgets/reset_password_dialog.dart';

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
  Future<void> pumpDialog(
    WidgetTester tester, {
    Future<Result<void>> Function(String password)? onSubmit,
    void Function(String? password)? onResult,
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
                    onPressed: () async {
                      final password = await showDialog<String>(
                        context: context,
                        builder: (_) => ResetPasswordDialog(
                          token: 'test-token',
                          email: 'user@example.com',
                          onSubmit: onSubmit ?? (_) async => const Success(null),
                        ),
                      );
                      onResult?.call(password);
                    },
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

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  // TextField order in the dialog: token, new password, confirm password.
  Finder passwordField() => find.byType(TextField).at(1);
  Finder confirmField() => find.byType(TextField).last;

  testWidgets('shows validation error and keeps dialog open for weak password',
      (tester) async {
    var submitted = 0;
    await pumpDialog(
      tester,
      onSubmit: (_) async {
        submitted++;
        return const Success(null);
      },
    );

    await tester.enterText(passwordField(), 'abc');
    await tester.tap(find.text('Reset'));
    await tester.pump();

    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(submitted, 0);
  });

  testWidgets('rejects common passwords client-side', (tester) async {
    var submitted = 0;
    await pumpDialog(
      tester,
      onSubmit: (_) async {
        submitted++;
        return const Success(null);
      },
    );

    await tester.enterText(passwordField(), 'password123');
    await tester.enterText(confirmField(), 'password123');
    await tester.tap(find.text('Reset'));
    await tester.pump();

    expect(find.text('Password is too common'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(submitted, 0);
  });

  testWidgets('shows mismatch error when confirm differs', (tester) async {
    await pumpDialog(tester);

    await tester.enterText(passwordField(), 'StrongPass1!');
    await tester.enterText(confirmField(), 'StrongPass2!');
    await tester.tap(find.text('Reset'));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('keeps dialog open and shows backend error, then submits again',
      (tester) async {
    var failFirst = true;
    String? result;
    await pumpDialog(
      tester,
      onSubmit: (_) async {
        if (failFirst) {
          failFirst = false;
          return const Error(ServerFailure('This password is too common.'));
        }
        return const Success(null);
      },
      onResult: (password) => result = password,
    );

    await tester.enterText(passwordField(), 'StrongPass1!');
    await tester.enterText(confirmField(), 'StrongPass1!');
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    // Backend rejected: dialog stays open and shows the error inline.
    expect(find.text('This password is too common.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(result, isNull);

    // Re-submitting succeeds and pops with the password.
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(result, 'StrongPass1!');
  });

  testWidgets('pops with the password when both fields validate',
      (tester) async {
    String? result;
    await pumpDialog(tester, onResult: (password) => result = password);

    await tester.enterText(passwordField(), 'StrongPass1!');
    await tester.enterText(confirmField(), 'StrongPass1!');
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(result, 'StrongPass1!');
  });
}
