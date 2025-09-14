// Service for managing local and push notifications
// Demonstrates consistent import patterns and service architecture
// that GitHub Copilot can learn from and suggest similar patterns

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';

/// Service class for managing all notification functionality
/// Demonstrates proper service pattern with clear method documentation
class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Consistent plugin initialization - helps Copilot learn patterns
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  final List<NotificationModel> _notifications = [];
  bool _isInitialized = false;

  /// Gets all notifications for display
  /// Public getter with clear documentation
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  /// Gets count of unread notifications
  /// Helper method for badge display
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Initializes notification service with proper platform configuration
  /// Centralized initialization method with error handling
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize local notifications with platform-specific settings
      await _initializeLocalNotifications();
      
      // Configure Firebase messaging for push notifications
      await _initializeFirebaseMessaging();
      
      // Load saved notifications from local storage
      await _loadSavedNotifications();
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }

  /// Configures local notifications for iOS and Android
  /// Platform-specific initialization with proper settings
  Future<void> _initializeLocalNotifications() async {
    // Android notification settings with proper channel configuration
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS notification settings with permissions
    const DarwinInitializationSettings iosSettings = 
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize with tap handler for notification interaction
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();
  }

  /// Creates Android notification channel for consistent styling
  /// Required for Android 8.0+ notification display
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'family_copilot_main',
      'Family Copilot Notifications',
      description: 'Main notification channel for Family Copilot app',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Configures Firebase messaging for push notifications
  /// Handles background and foreground message scenarios
  Future<void> _initializeFirebaseMessaging() async {
    // Request notification permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token for push notification targeting
      String? token = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      
      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    }
  }

  /// Handles incoming Firebase messages in foreground
  /// Converts Firebase message to local notification
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = _createNotificationFromRemoteMessage(message);
    addNotification(notification);
    
    // Show local notification for foreground messages
    _showLocalNotification(notification);
  }

  /// Creates NotificationModel from Firebase RemoteMessage
  /// Consistent data transformation pattern
  NotificationModel _createNotificationFromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'New Message',
      message: message.notification?.body ?? '',
      imageUrl: message.notification?.android?.imageUrl,
      timestamp: DateTime.now(),
      type: _getNotificationTypeFromData(message.data),
      metadata: message.data,
    );
  }

  /// Determines notification type from Firebase message data
  /// Smart categorization based on message content
  NotificationType _getNotificationTypeFromData(Map<String, dynamic> data) {
    final typeString = data['type'] as String?;
    return NotificationType.values.firstWhere(
      (type) => type.name == typeString,
      orElse: () => NotificationType.general,
    );
  }

  /// Shows local notification with proper styling
  /// Consistent notification display across platforms
  Future<void> _showLocalNotification(NotificationModel notification) async {
    final AndroidNotificationDetails androidDetails = 
        AndroidNotificationDetails(
      'family_copilot_main',
      'Family Copilot Notifications',
      channelDescription: 'Main notification channel for Family Copilot app',
      importance: Importance.high,
      priority: Priority.high,
      // Show large icon if image URL is available
      largeIcon: notification.imageUrl != null 
          ? NetworkAndroidBitmap(notification.imageUrl!)
          : null,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.id.hashCode,
      notification.title,
      notification.message,
      details,
      payload: notification.id,
    );
  }

  /// Handles notification tap events for navigation
  /// Routes users to appropriate screen based on notification
  void _onNotificationTapped(NotificationResponse response) {
    final notificationId = response.payload;
    if (notificationId != null) {
      _handleNotificationTap(null, notificationId: notificationId);
    }
  }

  /// Central handler for notification tap events
  /// Manages navigation and notification state updates
  void _handleNotificationTap(RemoteMessage? message, {String? notificationId}) {
    final targetId = notificationId ?? message?.messageId;
    if (targetId != null) {
      // Mark notification as read
      markAsRead(targetId);
      
      // Handle navigation based on notification type or metadata
      _navigateBasedOnNotification(targetId);
    }
  }

  /// Navigates to appropriate screen based on notification
  /// Smart routing based on notification content
  void _navigateBasedOnNotification(String notificationId) {
    final notification = _notifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => _notifications.first,
    );

    // Navigate based on notification type - Copilot can learn this pattern
    switch (notification.type) {
      case NotificationType.family:
        // Navigate to family screen
        break;
      case NotificationType.emergency:
        // Navigate to emergency contact screen
        break;
      case NotificationType.reminder:
        // Navigate to calendar/reminders
        break;
      default:
        // Navigate to main notifications screen
        break;
    }
  }

  /// Adds new notification to the list
  /// Public method for manual notification creation
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    _saveNotifications();
    notifyListeners();
  }

  /// Marks notification as read and updates UI
  /// State management method with persistence
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _saveNotifications();
      notifyListeners();
    }
  }

  /// Removes notification from the list
  /// Allows users to dismiss unwanted notifications
  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _saveNotifications();
    notifyListeners();
  }

  /// Clears all notifications
  /// Bulk action for notification management
  void clearAllNotifications() {
    _notifications.clear();
    _saveNotifications();
    notifyListeners();
  }

  /// Saves notifications to local storage for persistence
  /// Data persistence pattern that Copilot can learn
  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationJson = _notifications
          .map((notification) => notification.toJson())
          .toList();
      await prefs.setString('notifications', notificationJson.toString());
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  /// Loads saved notifications from local storage
  /// Data retrieval pattern with error handling
  Future<void> _loadSavedNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationData = prefs.getString('notifications');
      
      if (notificationData != null) {
        // Parse and load notifications (simplified for demonstration)
        // In real implementation, would properly parse JSON array
        debugPrint('Loading saved notifications: $notificationData');
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }
}