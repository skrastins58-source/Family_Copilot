// Notifications screen showing all user notifications
// Demonstrates list management and filtering that GitHub Copilot can learn from

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_state_provider.dart';
import '../services/notification_service.dart';
import '../widgets/notification_with_image_widget.dart';
import '../models/notification_model.dart';

/// Screen displaying all notifications with filtering and management options
/// Comprehensive notification management interface
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationType? _selectedFilter;
  bool _showOnlyUnread = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Builds app bar with filtering and action options
  /// Navigation and filtering controls in header
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Paziņojumi'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        // Filter toggle button
        IconButton(
          icon: Icon(
            _showOnlyUnread ? Icons.filter_alt : Icons.filter_alt_outlined,
          ),
          onPressed: () => setState(() => _showOnlyUnread = !_showOnlyUnread),
          tooltip: 'Rādīt tikai nelasītos',
        ),
        
        // Filter menu for notification types
        PopupMenuButton<NotificationType>(
          icon: const Icon(Icons.sort),
          tooltip: 'Filtrēt pēc veida',
          onSelected: (type) => setState(() => _selectedFilter = type),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: null,
              child: Text('Visi paziņojumi'),
            ),
            ...NotificationType.values.map(
              (type) => PopupMenuItem(
                value: type,
                child: Text(type.displayName),
              ),
            ),
          ],
        ),
        
        // Clear all notifications option
        IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: () => _showClearAllDialog(context),
          tooltip: 'Dzēst visus',
        ),
      ],
    );
  }

  /// Builds main body with filtered notification list
  /// Displays notifications based on current filter settings
  Widget _buildBody(BuildContext context) {
    return Consumer2<NotificationService, AppStateProvider>(
      builder: (context, notificationService, appState, child) {
        // Get notifications based on filters
        List<NotificationModel> notifications = _getFilteredNotifications(
          notificationService.notifications,
          appState,
        );

        if (notifications.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () => _refreshNotifications(context),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationWithImageWidget(
                notification: notification,
                onTap: () => _handleNotificationTap(context, notification),
                onDismiss: () => _handleNotificationDismiss(
                  context,
                  notification,
                  notificationService,
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Filters notifications based on current filter settings
  /// Smart filtering logic considering user preferences
  List<NotificationModel> _getFilteredNotifications(
    List<NotificationModel> allNotifications,
    AppStateProvider appState,
  ) {
    List<NotificationModel> filtered = allNotifications;

    // Apply app state filters for personalization
    filtered = appState.getFilteredNotifications(filtered);

    // Apply type filter if selected
    if (_selectedFilter != null) {
      filtered = filtered
          .where((notification) => notification.type == _selectedFilter)
          .toList();
    }

    // Apply unread filter if enabled
    if (_showOnlyUnread) {
      filtered = filtered
          .where((notification) => !notification.isRead)
          .toList();
    }

    return filtered;
  }

  /// Builds empty state when no notifications match filters
  /// Helpful message when notification list is empty
  Widget _buildEmptyState(BuildContext context) {
    String message;
    IconData icon;

    if (_showOnlyUnread) {
      message = 'Nav nelasītu paziņojumu';
      icon = Icons.mark_email_read;
    } else if (_selectedFilter != null) {
      message = 'Nav paziņojumu ar šo filtru';
      icon = Icons.filter_alt_off;
    } else {
      message = 'Nav paziņojumu';
      icon = Icons.inbox;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() {
              _selectedFilter = null;
              _showOnlyUnread = false;
            }),
            child: const Text('Notīrīt filtrus'),
          ),
        ],
      ),
    );
  }

  /// Handles notification tap for navigation to detail view
  /// Navigation pattern for notification details
  void _handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) {
    // Mark notification as read when tapped
    context.read<NotificationService>().markAsRead(notification.id);
    
    // Navigate to notification detail screen
    context.push('/notification/${notification.id}');
  }

  /// Handles notification dismissal with confirmation
  /// User feedback for notification removal
  void _handleNotificationDismiss(
    BuildContext context,
    NotificationModel notification,
    NotificationService service,
  ) {
    // Show confirmation snackbar with undo option
    service.removeNotification(notification.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Paziņojums "${notification.title}" tika dzēsts'),
        action: SnackBarAction(
          label: 'Atcelt',
          onPressed: () => service.addNotification(notification),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Refreshes notification list from server
  /// Pull-to-refresh functionality
  Future<void> _refreshNotifications(BuildContext context) async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    
    // In real app, would fetch new notifications from server
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paziņojumi atjaunoti'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Shows confirmation dialog for clearing all notifications
  /// Bulk action with user confirmation
  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dzēst visus paziņojumus?'),
        content: const Text(
          'Šī darbība dzēsīs visus paziņojumus un to nevarēs atcelt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Atcelt'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllNotifications(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Dzēst visus'),
          ),
        ],
      ),
    );
  }

  /// Clears all notifications with user feedback
  /// Bulk operation with confirmation feedback
  void _clearAllNotifications(BuildContext context) {
    final service = context.read<NotificationService>();
    service.clearAllNotifications();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Visi paziņojumi tika dzēsti'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Builds floating action button for creating new notifications
  /// Quick access for notification creation
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateNotificationDialog(context),
      tooltip: 'Izveidot paziņojumu',
      child: const Icon(Icons.add),
    );
  }

  /// Shows dialog for creating new notifications
  /// Simple notification creation interface
  void _showCreateNotificationDialog(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    NotificationType selectedType = NotificationType.general;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Izveidot paziņojumu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nosaukums',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Ziņojums',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<NotificationType>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Veids',
                  border: OutlineInputBorder(),
                ),
                items: NotificationType.values.map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  ),
                ).toList(),
                onChanged: (type) => setDialogState(() => selectedType = type!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Atcelt'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  _createNotification(
                    context,
                    titleController.text,
                    messageController.text,
                    selectedType,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Izveidot'),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates new notification and adds to service
  /// Notification creation with proper data structure
  void _createNotification(
    BuildContext context,
    String title,
    String message,
    NotificationType type,
  ) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message.isEmpty ? 'Nav apraksta' : message,
      timestamp: DateTime.now(),
      type: type,
    );

    context.read<NotificationService>().addNotification(notification);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Paziņojums "$title" tika izveidots'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}