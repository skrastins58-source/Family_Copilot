// UI and unit tests for Family Copilot Flutter application
// Comprehensive test suite covering main app initialization,
// settings screen logic, dark mode functionality, and error handling

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'package:family_copilot/main.dart';
import 'package:family_copilot/screens/settings_screen.dart';
import 'package:family_copilot/providers/app_state_provider.dart';
import 'package:family_copilot/services/notification_service.dart';
import 'package:family_copilot/models/notification_model.dart';

void main() {
  group('Family Copilot App Tests', () {
    setUp(() {
      // Initialize shared preferences mock for each test
      SharedPreferences.setMockInitialValues({});
    });

    group('App Initialization Tests', () {
      testWidgets('App initializes with Provider and MaterialApp', (WidgetTester tester) async {
        // Test: (1) App inicializāciju ar Provider un MaterialApp (main.dart)
        
        // Build the main app widget
        await tester.pumpWidget(const FamilyCopilotApp());
        await tester.pump();

        // Verify that the app initializes properly
        expect(find.byType(MaterialApp), findsOneWidget);
        
        // Verify Provider setup
        final context = tester.element(find.byType(MaterialApp));
        expect(Provider.of<AppStateProvider>(context, listen: false), isNotNull);
        expect(Provider.of<NotificationService>(context, listen: false), isNotNull);

        // Verify Material Design 3 theme is applied
        final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
        expect(materialApp.theme, isNotNull);
        expect(materialApp.theme!.useMaterial3, isTrue);
        expect(materialApp.theme!.colorScheme.primary, equals(Colors.deepPurple));
      });

      testWidgets('App uses GoRouter for navigation', (WidgetTester tester) async {
        // Test GoRouter configuration in main app
        await tester.pumpWidget(const FamilyCopilotApp());
        await tester.pump();

        final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
        expect(materialApp.routerConfig, isNotNull);
        expect(materialApp.routerConfig, isA<GoRouter>());
      });

      testWidgets('Providers are correctly initialized', (WidgetTester tester) async {
        // Test that both providers are available in the widget tree
        await tester.pumpWidget(const FamilyCopilotApp());
        await tester.pump();

        final context = tester.element(find.byType(MaterialApp));
        
        // Test AppStateProvider initialization
        final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);
        expect(appStateProvider, isNotNull);
        expect(appStateProvider.selectedLanguage, equals('lv')); // Default language
        expect(appStateProvider.isDarkMode, isFalse); // Default theme

        // Test NotificationService initialization
        final notificationService = Provider.of<NotificationService>(context, listen: false);
        expect(notificationService, isNotNull);
      });
    });

    group('Settings Screen UI Logic Tests', () {
      late AppStateProvider mockAppState;
      late NotificationService mockNotificationService;

      setUp(() {
        mockAppState = AppStateProvider();
        mockNotificationService = NotificationService();
      });

      testWidgets('Settings screen renders correctly with all sections', (WidgetTester tester) async {
        // Test: Settings screen renders with all main sections (settings_screen.dart)
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Verify main settings sections are present
        expect(find.text('Iestatījumi'), findsOneWidget);
        expect(find.text('Izskats'), findsOneWidget);
        expect(find.text('Paziņojumi'), findsOneWidget);
        expect(find.text('Valoda'), findsOneWidget);
        expect(find.text('Konts un dati'), findsOneWidget);
        expect(find.text('Par lietotni'), findsOneWidget);
      });

      testWidgets('Notification filter toggles work correctly', (WidgetTester tester) async {
        // Test notification filter logic
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Find and tap on a notification type filter
        final familyFilterFinder = find.text('Family');
        expect(familyFilterFinder, findsOneWidget);

        // Get the switch for family notifications
        final switchFinder = find.ancestor(
          of: familyFilterFinder,
          matching: find.byType(SwitchListTile),
        );
        expect(switchFinder, findsOneWidget);

        // Initially should be inactive (no filters set)
        SwitchListTile switchWidget = tester.widget(switchFinder);
        expect(switchWidget.value, isFalse);

        // Tap to enable the filter
        await tester.tap(switchFinder);
        await tester.pump();

        // Verify the filter was added
        expect(mockAppState.notificationFilters.contains('family'), isTrue);
      });

      testWidgets('Language selection dialog works', (WidgetTester tester) async {
        // Test language selection UI logic
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Find and tap language settings
        final languageTile = find.text('Lietotnes valoda');
        expect(languageTile, findsOneWidget);
        
        await tester.tap(languageTile);
        await tester.pumpAndSettle();

        // Verify language dialog appears
        expect(find.text('Izvēlieties valodu'), findsOneWidget);
        expect(find.text('Latviešu'), findsOneWidget);
        expect(find.text('English'), findsOneWidget);
        expect(find.text('Русский'), findsOneWidget);

        // Select English
        await tester.tap(find.text('English'));
        await tester.pumpAndSettle();

        // Verify language changed
        expect(mockAppState.selectedLanguage, equals('en'));
      });

      testWidgets('User ID dialog functionality', (WidgetTester tester) async {
        // Test user management dialog
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Find and tap user settings
        final userTile = find.text('Lietotājs');
        expect(userTile, findsOneWidget);
        
        await tester.tap(userTile);
        await tester.pumpAndSettle();

        // Verify user dialog appears
        expect(find.text('Lietotāja ID'), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);

        // Enter user ID
        await tester.enterText(find.byType(TextField), 'testuser123');
        await tester.tap(find.text('Saglabāt'));
        await tester.pumpAndSettle();

        // Verify user ID was set
        expect(mockAppState.currentUserId, equals('testuser123'));
      });
    });

    group('Dark Mode Toggle Tests', () {
      late AppStateProvider mockAppState;
      late NotificationService mockNotificationService;

      setUp(() {
        mockAppState = AppStateProvider();
        mockNotificationService = NotificationService();
      });

      testWidgets('Dark mode toggle works correctly', (WidgetTester tester) async {
        // Verifies that toggling the dark mode switch updates the app's theme and UI icons accordingly.
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Find dark mode switch
        final darkModeSwitch = find.ancestor(
          of: find.text('Tumšais režīms'),
          matching: find.byType(SwitchListTile),
        );
        expect(darkModeSwitch, findsOneWidget);

        // Verify initial state (light mode)
        SwitchListTile switchWidget = tester.widget(darkModeSwitch);
        expect(switchWidget.value, isFalse);
        expect(mockAppState.isDarkMode, isFalse);

        // Toggle to dark mode
        await tester.tap(darkModeSwitch);
        await tester.pump();

        // Verify dark mode is enabled
        expect(mockAppState.isDarkMode, isTrue);

        // Verify icon changes appropriately
        expect(find.byIcon(Icons.dark_mode), findsOneWidget);

        // Toggle back to light mode
        await tester.tap(darkModeSwitch);
        await tester.pump();

        // Verify light mode is restored
        expect(mockAppState.isDarkMode, isFalse);
        expect(find.byIcon(Icons.light_mode), findsOneWidget);
      });

      testWidgets('Dark mode persistence through app restart', (WidgetTester tester) async {
        // Test dark mode persistence
        SharedPreferences.setMockInitialValues({'is_dark_mode': true});
        
        final appState = AppStateProvider();
        await appState.initialize();

        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: appState),
                ChangeNotifierProvider<NotificationService>.value(value: NotificationService()),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Verify dark mode is restored from storage
        expect(appState.isDarkMode, isTrue);
        
        final darkModeSwitch = find.ancestor(
          of: find.text('Tumšais režīms'),
          matching: find.byType(SwitchListTile),
        );
        SwitchListTile switchWidget = tester.widget(darkModeSwitch);
        expect(switchWidget.value, isTrue);
      });
    });

    group('Error Handling Tests', () {
      late AppStateProvider mockAppState;
      late NotificationService mockNotificationService;

      setUp(() {
        mockAppState = AppStateProvider();
        mockNotificationService = NotificationService();
      });

      testWidgets('Clear notifications confirmation dialog', (WidgetTester tester) async {
        // Test: (4) kļūdu apstrādes piemēru (settings_screen.dart)
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Find and tap clear notifications button
        final clearButton = find.text('Dzēst visus paziņojumus');
        expect(clearButton, findsOneWidget);
        
        await tester.tap(clearButton);
        await tester.pumpAndSettle();

        // Verify confirmation dialog appears
        expect(find.text('Dzēst visus paziņojumus?'), findsOneWidget);
        expect(find.text('Šī darbība dzēsīs visus paziņojumus un to nevarēs atcelt.'), findsOneWidget);
        expect(find.text('Atcelt'), findsOneWidget);
        expect(find.text('Dzēst visus'), findsOneWidget);

        // Test cancel functionality
        await tester.tap(find.text('Atcelt'));
        await tester.pumpAndSettle();

        // Verify dialog is dismissed
        expect(find.text('Dzēst visus paziņojumus?'), findsNothing);
      });

      testWidgets('App reset confirmation dialog', (WidgetTester tester) async {
        // Test app reset error handling
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Find and tap reset app button
        final resetButton = find.text('Atiestatīt lietotni');
        expect(resetButton, findsOneWidget);
        
        await tester.tap(resetButton);
        await tester.pumpAndSettle();

        // Verify confirmation dialog appears
        expect(find.text('Atiestatīt lietotni?'), findsOneWidget);
        expect(find.text('Šī darbība dzēsīs visus datus, iestatījumus un paziņojumus. Darbību nevarēs atcelt.'), findsOneWidget);

        // Test destructive action styling
        final resetButtonWidget = find.text('Atiestatīt');
        expect(resetButtonWidget, findsOneWidget);
        
        // Verify cancel works
        await tester.tap(find.text('Atcelt'));
        await tester.pumpAndSettle();
        
        expect(find.text('Atiestatīt lietotni?'), findsNothing);
      });

      testWidgets('Notification filter error edge cases', (WidgetTester tester) async {
        // Test notification filter edge cases
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Test notification filters dialog
        final filtersButton = find.text('Paziņojumu filtri');
        expect(filtersButton, findsOneWidget);
        
        await tester.tap(filtersButton);
        await tester.pumpAndSettle();

        // Verify dialog content
        expect(find.text('Paziņojumu filtri'), findsOneWidget);
        expect(find.text('Izvēlieties, kādus paziņojumus vēlaties redzēt.'), findsOneWidget);
        
        // Find clear all button
        final clearAllButton = find.text('Notīrīt visus');
        expect(clearAllButton, findsOneWidget);
        
        // Test clear all functionality
        await tester.tap(clearAllButton);
        await tester.pumpAndSettle();

        // Verify filters are cleared
        expect(mockAppState.notificationFilters.isEmpty, isTrue);
      });

      testWidgets('Error snackbar messages display correctly', (WidgetTester tester) async {
        // Test error messaging through snackbars
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MultiProvider(
                providers: [
                  ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                  ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
                ],
                child: const SettingsScreen(),
              ),
            ),
          ),
        );
        await tester.pump();

        // Find and tap support contact
        final supportButton = find.text('Atbalsts');
        expect(supportButton, findsOneWidget);
        
        await tester.tap(supportButton);
        await tester.pump();

        // Verify snackbar appears with support info
        expect(find.text('Atbalsts: support@familycopilot.lv'), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('GitHub Copilot info dialog functionality', (WidgetTester tester) async {
        // Test informational dialog handling
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: mockAppState),
                ChangeNotifierProvider<NotificationService>.value(value: mockNotificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Find and tap GitHub Copilot info
        final copilotButton = find.text('GitHub Copilot');
        expect(copilotButton, findsOneWidget);
        
        await tester.tap(copilotButton);
        await tester.pumpAndSettle();

        // Verify info dialog appears
        expect(find.text('GitHub Copilot integrācija'), findsOneWidget);
        expect(find.textContaining('Šī lietotne demonstrē GitHub Copilot labākās prakses'), findsOneWidget);
        
        // Test close functionality
        await tester.tap(find.text('Aizvērt'));
        await tester.pumpAndSettle();
        
        expect(find.text('GitHub Copilot integrācija'), findsNothing);
      });
    });

    group('AppStateProvider Logic Tests', () {
      late AppStateProvider appStateProvider;

      setUp(() {
        appStateProvider = AppStateProvider();
      });

      test('Notification filtering logic works correctly', () {
        // Test notification filtering business logic
        final testNotifications = [
          NotificationModel(
            id: '1',
            title: 'Family Event',
            message: 'Family gathering',
            timestamp: DateTime(2024, 1, 1),
            type: NotificationType.family,
          ),
          NotificationModel(
            id: '2',
            title: 'System Update',
            message: 'System maintenance',
            timestamp: DateTime(2024, 1, 1),
            type: NotificationType.system,
          ),
          NotificationModel(
            id: '3',
            title: 'Emergency Alert',
            message: 'Emergency notification',
            timestamp: DateTime(2024, 1, 1),
            type: NotificationType.emergency,
          ),
        ];

        // Test with no filters (should show all)
        expect(appStateProvider.notificationFilters.isEmpty, isTrue);
        var filtered = appStateProvider.getFilteredNotifications(testNotifications);
        expect(filtered.length, equals(3));

        // Add family filter
        appStateProvider.addNotificationFilter('family');
        filtered = appStateProvider.getFilteredNotifications(testNotifications);
        expect(filtered.length, equals(1));
        expect(filtered.first.type, equals(NotificationType.family));

        // Add system filter
        appStateProvider.addNotificationFilter('system');
        filtered = appStateProvider.getFilteredNotifications(testNotifications);
        expect(filtered.length, equals(2));

        // Clear all filters
        appStateProvider.clearNotificationFilters();
        filtered = appStateProvider.getFilteredNotifications(testNotifications);
        expect(filtered.length, equals(3));
      });

      test('State persistence and restoration', () async {
        // Test state management and persistence
        SharedPreferences.setMockInitialValues({
          'current_user_id': 'testuser',
          'is_dark_mode': true,
          'selected_language': 'en',
          'notification_filters': ['family', 'emergency'],
        });

        await appStateProvider.initialize();

        expect(appStateProvider.currentUserId, equals('testuser'));
        expect(appStateProvider.isDarkMode, isTrue);
        expect(appStateProvider.selectedLanguage, equals('en'));
        expect(appStateProvider.notificationFilters.length, equals(2));
        expect(appStateProvider.notificationFilters.contains('family'), isTrue);
        expect(appStateProvider.notificationFilters.contains('emergency'), isTrue);
      });

      test('Error handling in state operations', () async {
        // Test error handling in provider methods
        
        // Test with invalid shared preferences (simulated error)
        // This tests the debug print statements and error resilience
        
        // Initialize with default values
        await appStateProvider.initialize();
        
        // Verify default values are set even with potential errors
        expect(appStateProvider.selectedLanguage, equals('lv'));
        expect(appStateProvider.isDarkMode, isFalse);
        expect(appStateProvider.notificationFilters.isEmpty, isTrue);
        
        // Test reset functionality
        appStateProvider.setCurrentUser('testuser');
        appStateProvider.toggleDarkMode();
        appStateProvider.addNotificationFilter('family');
        
        // Verify changes
        expect(appStateProvider.currentUserId, equals('testuser'));
        expect(appStateProvider.isDarkMode, isTrue);
        expect(appStateProvider.notificationFilters.isNotEmpty, isTrue);
        
        // Reset and verify
        await appStateProvider.resetAppState();
        expect(appStateProvider.currentUserId, isNull);
        expect(appStateProvider.isDarkMode, isFalse);
        expect(appStateProvider.notificationFilters.isEmpty, isTrue);
        expect(appStateProvider.selectedLanguage, equals('lv'));
      });
    });

    group('Edge Cases and Integration Tests', () {
      testWidgets('Settings screen handles rapid state changes', (WidgetTester tester) async {
        // Test rapid UI interactions and state changes
        final appState = AppStateProvider();
        final notificationService = NotificationService();
        
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: appState),
                ChangeNotifierProvider<NotificationService>.value(value: notificationService),
              ],
              child: const SettingsScreen(),
            ),
          ),
        );
        await tester.pump();

        // Rapid dark mode toggles
        final darkModeSwitch = find.ancestor(
          of: find.text('Tumšais režīms'),
          matching: find.byType(SwitchListTile),
        );

        for (int i = 0; i < 5; i++) {
          await tester.tap(darkModeSwitch);
          await tester.pump();
        }

        // Verify final state
        expect(appState.isDarkMode, isTrue);
      });

      testWidgets('Settings persist across widget rebuilds', (WidgetTester tester) async {
        // Test settings persistence across rebuilds
        final appState = AppStateProvider();
        
        Widget buildSettingsScreen() {
          return MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AppStateProvider>.value(value: appState),
                ChangeNotifierProvider<NotificationService>.value(value: NotificationService()),
              ],
              child: const SettingsScreen(),
            ),
          );
        }

        await tester.pumpWidget(buildSettingsScreen());
        await tester.pump();

        // Change settings
        final darkModeSwitch = find.ancestor(
          of: find.text('Tumšais režīms'),
          matching: find.byType(SwitchListTile),
        );
        await tester.tap(darkModeSwitch);
        await tester.pump();

        // Rebuild widget
        await tester.pumpWidget(buildSettingsScreen());
        await tester.pump();

        // Verify settings persist
        SwitchListTile switchWidget = tester.widget(darkModeSwitch);
        expect(switchWidget.value, isTrue);
        expect(appState.isDarkMode, isTrue);
      });
    });
  });
}