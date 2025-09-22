import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Accessibility screen reader simulation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Semantics(
          label: 'Pievienot ģimenes locekli',
          hint: 'Dubultklikšķis lai atvērtu formu',
          child: Scaffold(
            appBar: AppBar(title: const Text('Ģimenes profils')),
            body: Center(
              child: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/accessibility_screen_reader.png'),
    );
  });
}

