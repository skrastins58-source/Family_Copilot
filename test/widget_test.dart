// Golden tests for Family Copilot UI components
// Tests visual appearance of components against saved golden images
// to detect unintended UI changes

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Golden Tests', () {
    testWidgets('MyWidget golden test', (WidgetTester tester) async {
      // Create a simple widget with static content for golden testing
      final testWidget = MaterialApp(
        home: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: const Text(
              'Golden!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Compare the widget appearance with golden file
      await expectLater(
        find.byType(Container),
        matchesGoldenFile('goldens/my_widget.png'),
      );
    });

    testWidgets('MyWidget text golden test', (WidgetTester tester) async {
      // Test just the text widget for more focused golden testing
      final textWidget = MaterialApp(
        home: Material(
          child: Center(
            child: Text(
              'Golden!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(textWidget);
      await tester.pumpAndSettle();

      // Compare the text widget appearance with golden file
      await expectLater(
        find.text('Golden!'),
        matchesGoldenFile('goldens/golden_text.png'),
      );
    });

    testWidgets('Material Design Container golden test', (WidgetTester tester) async {
      // Test Material Design styled container
      final containerWidget = MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.deepPurple,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  'Golden!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(containerWidget);
      await tester.pumpAndSettle();

      // Compare the styled container with golden file
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/material_container.png'),
      );
    });
  });
}