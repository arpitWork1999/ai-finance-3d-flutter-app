import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_finance_app/core/constants/app_strings.dart';
import 'package:ai_finance_app/main.dart';

void main() {
  // no .env in tests, so the Market tab shows 'API key missing' instead of calling the API
  testWidgets('Dashboard switches between Market and Vastu tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AiFinanceApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('API key missing'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.vastuTitle).hitTestable(), findsOneWidget);
    expect(find.text(AppStrings.beforeVastu).hitTestable(), findsOneWidget);

    await tester.tap(find.text(AppStrings.applyVastu));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.vastuApplied).hitTestable(), findsOneWidget);
  });
}
