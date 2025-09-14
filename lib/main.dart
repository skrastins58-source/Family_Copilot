// Main entry point for Family Copilot Flutter application
// This file demonstrates GitHub Copilot best practices:
// 1. Clear, descriptive comments that explain purpose
// 2. Consistent import organization
// 3. Proper widget structure documentation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Consistent import grouping for better Copilot suggestions
import 'screens/home_screen.dart';
import 'screens/notifications_screen.dart';
import 'services/notification_service.dart';
import 'providers/app_state_provider.dart';
import 'utils/app_router.dart';

void main() {
  runApp(const FamilyCopilotApp());
}

/// Main application widget that configures providers and routing
/// Clear class documentation helps Copilot understand structure
class FamilyCopilotApp extends StatelessWidget {
  const FamilyCopilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize providers with clear comments about their purpose
    return MultiProvider(
      providers: [
        // Provider for managing global application state
        ChangeNotifierProvider(create: (context) => AppStateProvider()),
        
        // Provider for notification service management
        ChangeNotifierProvider(create: (context) => NotificationService()),
      ],
      child: MaterialApp.router(
        title: 'Family Copilot',
        
        // Material Design 3 theme configuration
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        
        // Configure routing using GoRouter for deep-link navigation
        routerConfig: AppRouter.router,
      ),
    );
  }
}