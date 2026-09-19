// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:civic_haven/app.dart';

void main() {
  testWidgets('CivicHaven shows emergency dashboard content', (tester) async {
    await tester.pumpWidget(const CivicHavenApp());

    expect(find.text('CivicHaven'), findsOneWidget);
    expect(find.text('Emergency'), findsAtLeastNWidgets(1));
    expect(find.text('Need Help?'), findsOneWidget);
  });
}
