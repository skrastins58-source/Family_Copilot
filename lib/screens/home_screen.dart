// Main home screen with navigation and notification overview
// Demonstrates Flutter screen structure that GitHub Copilot can learn from

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_state_provider.dart';
import '../services/notification_service.dart';
import '../widgets/notification_with_image_widget.dart';

/// Home screen with navigation and recent notifications
/// Main entry point showing app overview and quick actions
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize services when home screen loads
    _initializeServices();
  }

  /// Initializes required services for home screen functionality
  /// Centralized initialization pattern
  Future<void> _initializeServices() async {
    final appState = context.read<AppStateProvider>();
    final notificationService = context.read<NotificationService>();
    
    await Future.wait([
      appState.initialize(),
      notificationService.initialize(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Builds app bar with title and action buttons
  /// Consistent header across app with notification badge
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Family Copilot'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        // Notification badge icon with unread count
        Consumer<NotificationService>(
          builder: (context, notificationService, child) {
            final unreadCount = notificationService.unreadCount;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => context.push('/notifications'),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        
        // Settings access button
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => context.push('/settings'),
        ),
      ],
    );
  }

  /// Builds main body content based on selected tab
  /// Tab-based navigation with different content views
  Widget _buildBody(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return _buildOverviewTab(context);
      case 1:
        return _buildNotificationsTab(context);
      case 2:
        return _buildFamilyTab(context);
      default:
        return _buildOverviewTab(context);
    }
  }

  /// Builds overview tab with app summary and quick actions
  /// Dashboard view with key information and shortcuts
  Widget _buildOverviewTab(BuildContext context) {
    return Consumer2<AppStateProvider, NotificationService>(
      builder: (context, appState, notificationService, child) {
        if (appState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message with user context
              _buildWelcomeSection(context, appState),
              
              const SizedBox(height: 24),
              
              // Quick stats cards
              _buildStatsCards(context, notificationService),
              
              const SizedBox(height: 24),
              
              // Recent notifications preview
              _buildRecentNotificationsSection(context, notificationService),
              
              const SizedBox(height: 24),
              
              // Quick action buttons
              _buildQuickActions(context),
            ],
          ),
        );
      },
    );
  }

  /// Builds welcome section with personalized greeting
  /// Contextual welcome based on user state and time
  Widget _buildWelcomeSection(BuildContext context, AppStateProvider appState) {
    final hour = DateTime.now().hour;
    String greeting;
    
    if (hour < 12) {
      greeting = 'Labrīt'; // Good morning in Latvian
    } else if (hour < 17) {
      greeting = 'Labdien'; // Good afternoon in Latvian
    } else {
      greeting = 'Labvakar'; // Good evening in Latvian
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Jūsu ģimenes saziņas centrs ir gatavs darbam.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds statistics cards showing app usage metrics
  /// Visual metrics for user engagement and activity
  Widget _buildStatsCards(BuildContext context, NotificationService service) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Paziņojumi',
            '${service.notifications.length}',
            Icons.notifications,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Nelasīti',
            '${service.unreadCount}',
            Icons.mark_email_unread,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  /// Creates individual stat card with icon and number
  /// Reusable component for displaying metrics
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds recent notifications preview section
  /// Shows latest notifications with quick access
  Widget _buildRecentNotificationsSection(
    BuildContext context,
    NotificationService service,
  ) {
    final recentNotifications = service.notifications.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jaunākie paziņojumi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.push('/notifications'),
              child: const Text('Skatīt visus'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (recentNotifications.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nav jaunu paziņojumu',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...recentNotifications.map(
            (notification) => NotificationWithImageWidget(
              notification: notification,
              onTap: () => context.push('/notification/${notification.id}'),
              onDismiss: () => service.removeNotification(notification.id),
            ),
          ),
      ],
    );
  }

  /// Builds quick action buttons for common tasks
  /// Shortcut buttons for frequently used features
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ātrās darbības',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.push('/notifications'),
                icon: const Icon(Icons.notifications),
                label: const Text('Paziņojumi'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.settings),
                label: const Text('Iestatījumi'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Placeholder for notifications tab content
  /// Tab view focused on notification management
  Widget _buildNotificationsTab(BuildContext context) {
    return const Center(
      child: Text('Notifications Tab - Full notification management'),
    );
  }

  /// Placeholder for family tab content
  /// Tab view for family-specific features
  Widget _buildFamilyTab(BuildContext context) {
    return const Center(
      child: Text('Family Tab - Family member management'),
    );
  }

  /// Builds bottom navigation bar for app sections
  /// Standard bottom navigation with clear icons and labels
  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Sākums',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Paziņojumi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.family_restroom),
          label: 'Ģimene',
        ),
      ],
    );
  }

  /// Builds floating action button for quick notification creation
  /// Quick access for creating new notifications or messages
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateNotificationDialog(context),
      tooltip: 'Izveidot paziņojumu',
      child: const Icon(Icons.add),
    );
  }

  /// Shows dialog for creating new notifications
  /// Quick notification creation feature
  void _showCreateNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Izveidot paziņojumu'),
        content: const Text('Šeit būs veidlapa jauna paziņojuma izveidošanai.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Atcelt'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Izveidot'),
          ),
        ],
      ),
    );
  }
}