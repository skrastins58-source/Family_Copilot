// Global application state management provider
// Demonstrates state management patterns that GitHub Copilot can learn from

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';

/// Central state management for Family Copilot application
/// Provides global state with proper documentation for Copilot learning
class AppStateProvider extends ChangeNotifier {
  // Private state variables with clear naming conventions
  bool _isLoading = false;
  String? _currentUserId;
  List<String> _notificationFilters = [];
  bool _isDarkMode = false;
  String _selectedLanguage = 'lv'; // Default to Latvian
  
  // Public getters with clear documentation
  /// Indicates if app is currently loading data
  bool get isLoading => _isLoading;
  
  /// Current authenticated user ID
  String? get currentUserId => _currentUserId;
  
  /// Active notification filters for personalized content
  List<String> get notificationFilters => List.unmodifiable(_notificationFilters);
  
  /// Current theme mode preference
  bool get isDarkMode => _isDarkMode;
  
  /// Selected app language code
  String get selectedLanguage => _selectedLanguage;

  /// Initializes app state from persistent storage
  /// Loads user preferences and settings on app startup
  Future<void> initialize() async {
    setLoading(true);
    
    try {
      await _loadUserPreferences();
      await _loadNotificationFilters();
    } catch (e) {
      debugPrint('Error initializing app state: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Sets loading state and notifies listeners
  /// Centralized loading state management
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Updates current user ID and persists to storage
  /// User authentication state management
  Future<void> setCurrentUser(String? userId) async {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      await _saveUserPreferences();
      notifyListeners();
    }
  }

  /// Toggles dark mode theme and saves preference
  /// Theme management with persistence
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _saveUserPreferences();
    notifyListeners();
  }

  /// Changes app language and updates UI
  /// Internationalization support with persistence
  Future<void> setLanguage(String languageCode) async {
    if (_selectedLanguage != languageCode) {
      _selectedLanguage = languageCode;
      await _saveUserPreferences();
      notifyListeners();
    }
  }

  /// Adds notification filter for personalized content
  /// Smart filtering system for relevant notifications only
  Future<void> addNotificationFilter(String filter) async {
    if (!_notificationFilters.contains(filter)) {
      _notificationFilters.add(filter);
      await _saveNotificationFilters();
      notifyListeners();
    }
  }

  /// Removes notification filter from active list
  /// Allows users to customize their notification preferences
  Future<void> removeNotificationFilter(String filter) async {
    if (_notificationFilters.remove(filter)) {
      await _saveNotificationFilters();
      notifyListeners();
    }
  }

  /// Clears all notification filters
  /// Reset functionality for notification preferences
  Future<void> clearNotificationFilters() async {
    if (_notificationFilters.isNotEmpty) {
      _notificationFilters.clear();
      await _saveNotificationFilters();
      notifyListeners();
    }
  }

  /// Checks if notification matches current filters
  /// Smart filtering logic for personalized content delivery
  bool shouldShowNotification(NotificationModel notification) {
    // If no filters are set, show all notifications
    if (_notificationFilters.isEmpty) return true;
    
    // Check if notification type matches any active filter
    final typeFilter = notification.type.name;
    if (_notificationFilters.contains(typeFilter)) return true;
    
    // Check metadata for additional filter criteria
    if (notification.metadata != null) {
      for (final filter in _notificationFilters) {
        if (notification.metadata!.containsValue(filter)) {
          return true;
        }
      }
    }
    
    return false;
  }

  /// Gets filtered notifications based on user preferences
  /// Returns only notifications that match active filters
  List<NotificationModel> getFilteredNotifications(
    List<NotificationModel> allNotifications,
  ) {
    return allNotifications
        .where((notification) => shouldShowNotification(notification))
        .toList();
  }

  /// Loads user preferences from persistent storage
  /// Private method for initialization
  Future<void> _loadUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUserId = prefs.getString('current_user_id');
      _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
      _selectedLanguage = prefs.getString('selected_language') ?? 'lv';
    } catch (e) {
      debugPrint('Error loading user preferences: $e');
    }
  }

  /// Saves user preferences to persistent storage
  /// Ensures settings persist across app sessions
  Future<void> _saveUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_currentUserId != null) {
        await prefs.setString('current_user_id', _currentUserId!);
      } else {
        await prefs.remove('current_user_id');
      }
      
      await prefs.setBool('is_dark_mode', _isDarkMode);
      await prefs.setString('selected_language', _selectedLanguage);
    } catch (e) {
      debugPrint('Error saving user preferences: $e');
    }
  }

  /// Loads notification filters from storage
  /// Restores user's personalization settings
  Future<void> _loadNotificationFilters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _notificationFilters = prefs.getStringList('notification_filters') ?? [];
    } catch (e) {
      debugPrint('Error loading notification filters: $e');
    }
  }

  /// Saves notification filters to storage
  /// Persists user's filtering preferences
  Future<void> _saveNotificationFilters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('notification_filters', _notificationFilters);
    } catch (e) {
      debugPrint('Error saving notification filters: $e');
    }
  }

  /// Resets all app state to defaults
  /// Useful for logout or app reset functionality
  Future<void> resetAppState() async {
    _isLoading = false;
    _currentUserId = null;
    _notificationFilters.clear();
    _isDarkMode = false;
    _selectedLanguage = 'lv';
    
    // Clear persistent storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error clearing app state: $e');
    }
    
    notifyListeners();
  }
}