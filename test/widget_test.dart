import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_finance_app/main.dart';

void main() {
  // Tests run without env.json, so the Market tab shows the
  // "API key missing" message instead of calling the real API.
  testWidgets('Dashboard switches between Market and Vastu tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AiFinanceApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('API key missing'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    expect(
      find.text('3D interior placement as per Vastu - coming soon'),
      findsOneWidget,
    );
  });
}
