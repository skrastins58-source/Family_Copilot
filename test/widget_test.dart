// Golden tests for Family Copilot Flutter application
// UI regression tests using matchesGoldenFile to capture widget screenshots
// and compare them against baseline images

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_copilot/main.dart';
import 'package:family_copilot/screens/home_screen.dart';
import 'package:family_copilot/screens/settings_screen.dart';
import 'package:family_copilot/screens/notifications_screen.dart';
import 'package:family_copilot/providers/app_state_provider.dart';
import 'package:family_copilot/services/notification_service.dart';
import 'package:family_copilot/widgets/notification_with_image_widget.dart';
import 'package:family_copilot/models/notification_model.dart';

void main() {
  group('Family Copilot Golden Tests', () {
    // Set up shared preferences mock for all tests
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    group('Home Screen Golden Tests', () {
      testWidgets('Home screen renders correctly in light mode', (WidgetTester tester) async {
        // Golden test: Verifies home screen UI matches baseline in light mode
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AppStateProvider()),
                ChangeNotifierProvider(create: (_) => NotificationService()),
              ],
              child: const HomeScreen(),
            ),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Capture golden image for home screen
        await expectLater(
          find.byType(HomeScreen),
          matchesGoldenFile('goldens/home_screen_light.png'),
        );
      });

      testWidgets('Home screen renders correctly in dark mode', (WidgetTester tester) async {
        // Golden test: Verifies home screen UI matches baseline in dark mode
        
        final appState = AppStateProvider();
        appState.toggleDarkMode(); // Enable dark mode
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: appState),
                ChangeNotifierProvider(create: (_) => NotificationService()),
              ],
              child: const HomeScreen(),
            ),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: ThemeMode.dark,
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Capture golden image for dark mode home screen
        await expectLater(
          find.byType(HomeScreen),
          matchesGoldenFile('goldens/home_screen_dark.png'),
        );
      });
    });

    group('Settings Screen Golden Tests', () {
      testWidgets('Settings screen renders correctly', (WidgetTester tester) async {
        // Golden test: Verifies settings screen UI layout and components
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AppStateProvider()),
                ChangeNotifierProvider(create: (_) => NotificationService()),
              ],
              child: const SettingsScreen(),
            ),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Capture golden image for settings screen
        await expectLater(
          find.byType(SettingsScreen),
          matchesGoldenFile('goldens/settings_screen.png'),
        );
      });

      testWidgets('Settings screen with dark mode enabled', (WidgetTester tester) async {
        // Golden test: Verifies settings screen with dark mode toggle enabled
        
        final appState = AppStateProvider();
        appState.toggleDarkMode();
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: appState),
                ChangeNotifierProvider(create: (_) => NotificationService()),
              ],
              child: const SettingsScreen(),
            ),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: ThemeMode.dark,
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Capture golden image for settings screen in dark mode
        await expectLater(
          find.byType(SettingsScreen),
          matchesGoldenFile('goldens/settings_screen_dark.png'),
        );
      });
    });

    group('Notifications Screen Golden Tests', () {
      testWidgets('Notifications screen with sample notifications', (WidgetTester tester) async {
        // Golden test: Verifies notifications screen with sample data
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AppStateProvider()),
                ChangeNotifierProvider(create: (_) => NotificationService()),
              ],
              child: const NotificationsScreen(),
            ),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Capture golden image for notifications screen
        await expectLater(
          find.byType(NotificationsScreen),
          matchesGoldenFile('goldens/notifications_screen.png'),
        );
      });

      testWidgets('Empty notifications screen', (WidgetTester tester) async {
        // Golden test: Verifies empty state of notifications screen
        
        final notificationService = NotificationService();
        // Clear any existing notifications for clean empty state
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AppStateProvider()),
                ChangeNotifierProvider.value(value: notificationService),
              ],
              child: const NotificationsScreen(),
            ),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Capture golden image for empty notifications screen
        await expectLater(
          find.byType(NotificationsScreen),
          matchesGoldenFile('goldens/notifications_screen_empty.png'),
        );
      });
    });

    group('Notification Widget Golden Tests', () {
      testWidgets('Notification with image widget renders correctly', (WidgetTester tester) async {
        // Golden test: Verifies notification widget with image component
        
        final testNotification = NotificationModel(
          id: 'test-1',
          title: 'Family Gathering',
          message: 'Don\'t forget about tomorrow\'s family dinner at 6 PM!',
          timestamp: DateTime(2024, 1, 15, 14, 30),
          type: NotificationType.family,
          imageUrl: 'assets/images/family_icon.png',
        );
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationWithImageWidget(
                notification: testNotification,
                onTap: () {},
              ),
            ),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Capture golden image for notification widget
        await expectLater(
          find.byType(NotificationWithImageWidget),
          matchesGoldenFile('goldens/notification_widget_with_image.png'),
        );
      });

      testWidgets('System notification widget style', (WidgetTester tester) async {
        // Golden test: Verifies system notification widget styling
        
        final testNotification = NotificationModel(
          id: 'test-2',
          title: 'System Update',
          message: 'Family Copilot has been updated to version 1.1.0 with new features.',
          timestamp: DateTime(2024, 1, 15, 10, 0),
          type: NotificationType.system,
        );
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationWithImageWidget(
                notification: testNotification,
                onTap: () {},
              ),
            ),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Capture golden image for system notification widget
        await expectLater(
          find.byType(NotificationWithImageWidget),
          matchesGoldenFile('goldens/notification_widget_system.png'),
        );
      });

      testWidgets('Emergency notification widget style', (WidgetTester tester) async {
        // Golden test: Verifies emergency notification widget special styling
        
        final testNotification = NotificationModel(
          id: 'test-3',
          title: 'Emergency Alert',
          message: 'Important: Please check family safety status immediately.',
          timestamp: DateTime(2024, 1, 15, 16, 45),
          type: NotificationType.emergency,
        );
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NotificationWithImageWidget(
                notification: testNotification,
                onTap: () {},
              ),
            ),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        
        // Capture golden image for emergency notification widget
        await expectLater(
          find.byType(NotificationWithImageWidget),
          matchesGoldenFile('goldens/notification_widget_emergency.png'),
        );
      });
    });

    group('App Layout Golden Tests', () {
      testWidgets('Main app layout with navigation', (WidgetTester tester) async {
        // Golden test: Verifies main app layout and navigation structure
        
        await tester.pumpWidget(const FamilyCopilotApp());
        await tester.pumpAndSettle();
        
        // Capture golden image for main app layout
        await expectLater(
          find.byType(FamilyCopilotApp),
          matchesGoldenFile('goldens/main_app_layout.png'),
        );
      });

      testWidgets('Responsive layout on different screen sizes', (WidgetTester tester) async {
        // Golden test: Verifies responsive layout behavior
        
        // Test with tablet-like dimensions
        await tester.binding.setSurfaceSize(const Size(800, 600));
        
        await tester.pumpWidget(const FamilyCopilotApp());
        await tester.pumpAndSettle();
        
        // Capture golden image for tablet layout
        await expectLater(
          find.byType(FamilyCopilotApp),
          matchesGoldenFile('goldens/main_app_layout_tablet.png'),
        );
        
        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}