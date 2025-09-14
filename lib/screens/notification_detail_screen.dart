// Detailed view for individual notifications
// Demonstrates detail screen pattern that GitHub Copilot can learn from

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../services/notification_service.dart';
import '../models/notification_model.dart';

/// Detail screen for viewing individual notification content
/// Full notification display with actions and metadata
class NotificationDetailScreen extends StatelessWidget {
  final String notificationId;

  const NotificationDetailScreen({
    super.key,
    required this.notificationId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationService>(
      builder: (context, notificationService, child) {
        // Find notification by ID
        final notification = notificationService.notifications.firstWhere(
          (n) => n.id == notificationId,
          orElse: () => _createNotFoundNotification(),
        );

        // Mark as read when viewing details
        if (!notification.isRead && notification.id != 'not_found') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notificationService.markAsRead(notificationId);
          });
        }

        return Scaffold(
          appBar: _buildAppBar(context, notification),
          body: _buildBody(context, notification, notificationService),
        );
      },
    );
  }

  /// Creates placeholder notification for not found cases
  /// Error handling for invalid notification IDs
  NotificationModel _createNotFoundNotification() {
    return NotificationModel(
      id: 'not_found',
      title: 'Paziņojums nav atrasts',
      message: 'Šis paziņojums vairs neeksistē vai tika dzēsts.',
      timestamp: DateTime.now(),
      type: NotificationType.system,
    );
  }

  /// Builds app bar with notification actions
  /// Header with navigation and action buttons
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    NotificationModel notification,
  ) {
    return AppBar(
      title: Text(
        notification.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        // Share notification button
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareNotification(context, notification),
          tooltip: 'Dalīties',
        ),
        
        // Delete notification button
        if (notification.id != 'not_found')
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteNotification(context, notification),
            tooltip: 'Dzēst',
          ),
      ],
    );
  }

  /// Builds main content area with notification details
  /// Comprehensive display of notification information
  Widget _buildBody(
    BuildContext context,
    NotificationModel notification,
    NotificationService service,
  ) {
    if (notification.id == 'not_found') {
      return _buildNotFoundContent(context);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification header with image and metadata
          _buildNotificationHeader(context, notification),
          
          const SizedBox(height: 24),
          
          // Main notification content
          _buildNotificationContent(context, notification),
          
          const SizedBox(height: 24),
          
          // Notification metadata section
          _buildNotificationMetadata(context, notification),
          
          const SizedBox(height: 32),
          
          // Action buttons
          _buildActionButtons(context, notification, service),
        ],
      ),
    );
  }

  /// Builds content for not found notifications
  /// Error state with helpful guidance
  Widget _buildNotFoundContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Paziņojums nav atrasts',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Šis paziņojums vairs neeksistē vai tika dzēsts.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Atgriezties'),
          ),
        ],
      ),
    );
  }

  /// Builds notification header with image and type indicator
  /// Visual header with notification branding
  Widget _buildNotificationHeader(
    BuildContext context,
    NotificationModel notification,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Notification image or icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: notification.imageUrl != null
                    ? Image.network(
                        notification.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildDefaultIcon(notification.type),
                      )
                    : _buildDefaultIcon(notification.type),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Notification title and type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(notification.type.displayName),
                    backgroundColor: _getTypeColor(notification.type),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds default icon for notification type
  /// Fallback icon when image is not available
  Widget _buildDefaultIcon(NotificationType type) {
    return Container(
      decoration: BoxDecoration(
        color: _getTypeColor(type),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getTypeIcon(type),
        size: 40,
        color: Colors.white,
      ),
    );
  }

  /// Gets color for notification type
  /// Visual coding by notification category
  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.family:
        return Colors.green;
      case NotificationType.emergency:
        return Colors.red;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.system:
        return Colors.blue;
      case NotificationType.update:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /// Gets icon for notification type
  /// Visual representation of notification category
  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.family:
        return Icons.family_restroom;
      case NotificationType.emergency:
        return Icons.emergency;
      case NotificationType.reminder:
        return Icons.schedule;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.update:
        return Icons.system_update;
      default:
        return Icons.notifications;
    }
  }

  /// Builds main notification content section
  /// Primary message content display
  Widget _buildNotificationContent(
    BuildContext context,
    NotificationModel notification,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saturs',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              notification.message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds notification metadata section
  /// Additional information and technical details
  Widget _buildNotificationMetadata(
    BuildContext context,
    NotificationModel notification,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detaļas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildMetadataRow('ID', notification.id),
            _buildMetadataRow('Veids', notification.type.displayName),
            _buildMetadataRow('Laiks', _formatFullTimestamp(notification.timestamp)),
            _buildMetadataRow('Status', notification.isRead ? 'Izlasīts' : 'Nelasīts'),
            if (notification.metadata != null && notification.metadata!.isNotEmpty)
              ...notification.metadata!.entries.map(
                (entry) => _buildMetadataRow(entry.key, entry.value.toString()),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds individual metadata row
  /// Key-value display for notification properties
  Widget _buildMetadataRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$key:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// Builds action buttons for notification management
  /// Primary actions user can take on notification
  Widget _buildActionButtons(
    BuildContext context,
    NotificationModel notification,
    NotificationService service,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _shareNotification(context, notification),
            icon: const Icon(Icons.share),
            label: const Text('Dalīties'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _deleteNotification(context, notification),
            icon: const Icon(Icons.delete),
            label: const Text('Dzēst'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// Shares notification content with other apps
  /// Social sharing functionality
  void _shareNotification(BuildContext context, NotificationModel notification) {
    // In real app, would use share_plus package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dalīties ar: ${notification.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Deletes notification with confirmation
  /// Removal action with user feedback
  void _deleteNotification(BuildContext context, NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dzēst paziņojumu?'),
        content: Text('Vai tiešām vēlaties dzēst "${notification.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Atcelt'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<NotificationService>().removeNotification(notification.id);
              context.pop(); // Return to previous screen
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Paziņojums tika dzēsts'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Dzēst'),
          ),
        ],
      ),
    );
  }

  /// Formats timestamp for relative display
  /// Human-readable time formatting
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} dienas atpakaļ';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} stundas atpakaļ';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minūtes atpakaļ';
    } else {
      return 'Tikko';
    }
  }

  /// Formats timestamp for detailed display
  /// Full date and time formatting
  String _formatFullTimestamp(DateTime timestamp) {
    return '${timestamp.day}.${timestamp.month}.${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}