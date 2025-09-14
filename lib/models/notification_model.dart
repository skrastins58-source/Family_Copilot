// Data model for notifications in Family Copilot app
// Demonstrates proper model structure that Copilot can learn from

/// Notification data model for managing app notifications
/// Clear class documentation helps Copilot understand data structure
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String? imageUrl;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.imageUrl,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.metadata,
  });

  /// Creates a copy of notification with updated properties
  /// Immutable data pattern for better state management
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? imageUrl,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts notification to JSON for storage/transmission
  /// Consistent serialization pattern for Copilot learning
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'isRead': isRead,
      'metadata': metadata,
    };
  }

  /// Creates notification from JSON data
  /// Factory constructor for data deserialization
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      imageUrl: json['imageUrl'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      isRead: json['isRead'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Enumeration of notification types for categorization
/// Clear enum helps Copilot understand different notification categories
enum NotificationType {
  general,
  family,
  emergency,
  reminder,
  system,
  update,
}

/// Extension for notification type display
/// Provides user-friendly names for notification types
extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.general:
        return 'General';
      case NotificationType.family:
        return 'Family';
      case NotificationType.emergency:
        return 'Emergency';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.system:
        return 'System';
      case NotificationType.update:
        return 'Update';
    }
  }

  /// Gets appropriate icon for notification type
  /// Visual consistency across notification displays
  String get iconName {
    switch (this) {
      case NotificationType.general:
        return 'notifications';
      case NotificationType.family:
        return 'family_restroom';
      case NotificationType.emergency:
        return 'emergency';
      case NotificationType.reminder:
        return 'schedule';
      case NotificationType.system:
        return 'settings';
      case NotificationType.update:
        return 'system_update';
    }
  }
}