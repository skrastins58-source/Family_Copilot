import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:family_copilot/widgets/notification_preview.dart';

void main() {
  group('Golden Tests', () {
    testWidgets('Simple text golden test', (WidgetTester tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Center(
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

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/expected/golden_text.png'),
      );
    });

    testWidgets('Material container golden test', (WidgetTester tester) async {
      final widget = MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
          body: Center(
            child: Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple, width: 2),
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

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/expected/material_container.png'),
      );
    });
  });
}
