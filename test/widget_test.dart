import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffeeshop_app/core/widgets/app_button.dart';

void main() {
  testWidgets('AppButton renders text and responds to tap', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Tap me',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Tap me'), findsOneWidget);
    expect(tapped, isFalse);

    await tester.tap(find.text('Tap me'));
    expect(tapped, isTrue);
  });

  testWidgets('AppButton shows loader when isLoading is true', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Loading',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsNothing);
  });
}
