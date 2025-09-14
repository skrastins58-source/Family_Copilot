// Izveido widgetu, kas parāda paziņojumu ar attēlu
// This widget demonstrates how to create notifications with images
// Clear comments in both Latvian and English help Copilot understand context

import 'package:flutter/material.dart';
import '../models/notification_model.dart';

/// Widget that displays a notification with an image
/// Demonstrates proper Flutter widget documentation for Copilot
class NotificationWithImageWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationWithImageWidget({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Material Design 3 card styling for notification container
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        // Handle notification tap interaction
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification image container with proper sizing
              _buildNotificationImage(),
              
              const SizedBox(width: 12),
              
              // Notification content area (title, message, timestamp)
              Expanded(child: _buildNotificationContent(context)),
              
              // Dismiss button for notification management
              _buildDismissButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the notification image with fallback handling
  /// Clear method names help Copilot understand component purpose
  Widget _buildNotificationImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: notification.imageUrl != null
            ? Image.network(
                notification.imageUrl!,
                fit: BoxFit.cover,
                // Error handling for failed image loading
                errorBuilder: (context, error, stackTrace) => 
                    _buildDefaultNotificationIcon(),
              )
            : _buildDefaultNotificationIcon(),
      ),
    );
  }

  /// Creates default notification icon when image is unavailable
  /// Provides consistent fallback experience
  Widget _buildDefaultNotificationIcon() {
    return Icon(
      Icons.notifications,
      size: 30,
      color: Colors.grey[600],
    );
  }

  /// Builds the main notification content area
  /// Organizes title, message, and timestamp in readable format
  Widget _buildNotificationContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Notification title with proper typography
        Text(
          notification.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // Notification message content
        Text(
          notification.message,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // Timestamp display with relative time formatting
        Text(
          _formatTimestamp(notification.timestamp),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Creates dismiss button for notification management
  /// Allows users to remove notifications from their feed
  Widget _buildDismissButton() {
    return IconButton(
      icon: const Icon(Icons.close, size: 20),
      onPressed: onDismiss,
      tooltip: 'Dismiss notification', // Accessibility support
    );
  }

  /// Formats timestamp to human-readable relative time
  /// Helper method for better user experience
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}