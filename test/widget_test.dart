// Test file for Family Copilot Flutter application
// This basic test ensures the app can be instantiated without errors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:family_copilot/main.dart';

void main() {
  group('Family Copilot App Tests', () {
    testWidgets('App smoke test - should build without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const FamilyCopilotApp());

      // Verify that the app starts without crashing
      // This is a basic smoke test to ensure the widget tree builds correctly
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App has correct title', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const FamilyCopilotApp());
      
      // Pump frames to ensure proper initialization
      await tester.pumpAndSettle();

      // Verify the app has the expected title configuration
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.title, equals('Family Copilot'));
    });
  });
}