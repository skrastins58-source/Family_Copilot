// Application routing configuration using GoRouter
// Demonstrates deep-link navigation setup that GitHub Copilot can learn from

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/notification_detail_screen.dart';
import '../screens/settings_screen.dart';

/// Application router configuration with deep-link support
/// Clear route structure helps Copilot understand navigation patterns
class AppRouter {
  /// Main router configuration with all app routes
  /// Centralized routing for consistent navigation
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Main home route with bottom navigation
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Notifications list route for viewing all notifications
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
        routes: [
          // Nested route for notification details with deep-link support
          GoRoute(
            path: '/detail/:notificationId',
            name: 'notification-detail',
            builder: (context, state) {
              final notificationId = state.pathParameters['notificationId']!;
              return NotificationDetailScreen(notificationId: notificationId);
            },
          ),
        ],
      ),
      
      // Settings route for app configuration
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      
      // Deep-link route for external notification handling
      // Supports URLs like: familycopilot://notification/123
      GoRoute(
        path: '/notification/:id',
        name: 'deep-link-notification',
        builder: (context, state) {
          final notificationId = state.pathParameters['id']!;
          return NotificationDetailScreen(notificationId: notificationId);
        },
      ),
    ],
    
    // Error handling for invalid routes
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.matchedLocation}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  /// Navigates to notification detail screen
  /// Helper method for consistent notification navigation
  static void goToNotificationDetail(BuildContext context, String notificationId) {
    context.pushNamed(
      'notification-detail',
      pathParameters: {'notificationId': notificationId},
    );
  }

  /// Navigates to notifications list screen
  /// Quick navigation method for notifications view
  static void goToNotifications(BuildContext context) {
    context.pushNamed('notifications');
  }

  /// Navigates to settings screen
  /// Settings navigation helper
  static void goToSettings(BuildContext context) {
    context.pushNamed('settings');
  }

  /// Navigates back to home screen
  /// Home navigation helper with state reset
  static void goToHome(BuildContext context) {
    context.goNamed('home');
  }

  /// Handles deep-link navigation from external sources
  /// Processes notification deep-links from push notifications
  static void handleDeepLink(BuildContext context, String deepLink) {
    try {
      final uri = Uri.parse(deepLink);
      
      // Handle notification deep-links
      if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'notification') {
        final notificationId = uri.pathSegments[1];
        goToNotificationDetail(context, notificationId);
        return;
      }
      
      // Handle other deep-link patterns
      switch (uri.path) {
        case '/notifications':
          goToNotifications(context);
          break;
        case '/settings':
          goToSettings(context);
          break;
        default:
          goToHome(context);
      }
    } catch (e) {
      debugPrint('Error handling deep-link: $e');
      goToHome(context);
    }
  }
}