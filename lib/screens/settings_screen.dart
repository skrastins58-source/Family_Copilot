// Settings screen for app configuration and preferences
// Demonstrates settings UI patterns that GitHub Copilot can learn from

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state_provider.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';

/// Settings screen for managing app preferences and configuration
/// Comprehensive settings interface with proper organization
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  /// Builds app bar with title and save actions
  /// Standard settings screen header
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Iestatījumi'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  /// Builds main settings content with organized sections
  /// Grouped settings for better user experience
  Widget _buildBody(BuildContext context) {
    return Consumer2<AppStateProvider, NotificationService>(
      builder: (context, appState, notificationService, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // App appearance settings
            _buildAppearanceSection(context, appState),
            
            const SizedBox(height: 24),
            
            // Notification settings
            _buildNotificationSection(context, appState, notificationService),
            
            const SizedBox(height: 24),
            
            // Language and localization settings
            _buildLanguageSection(context, appState),
            
            const SizedBox(height: 24),
            
            // Account and data settings
            _buildAccountSection(context, appState),
            
            const SizedBox(height: 24),
            
            // About and support section
            _buildAboutSection(context),
          ],
        );
      },
    );
  }

  /// Builds appearance settings section
  /// Theme and visual customization options
  Widget _buildAppearanceSection(BuildContext context, AppStateProvider appState) {
    return _buildSettingsCard(
      context,
      title: 'Izskats',
      icon: Icons.palette,
      children: [
        // Dark mode toggle
        SwitchListTile(
          title: const Text('Tumšais režīms'),
          subtitle: const Text('Izmanto tumšo krāsu shēmu'),
          value: appState.isDarkMode,
          onChanged: (value) => appState.toggleDarkMode(),
          secondary: Icon(
            appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          ),
        ),
      ],
    );
  }

  /// Builds notification settings section
  /// Comprehensive notification management and filtering
  Widget _buildNotificationSection(
    BuildContext context,
    AppStateProvider appState,
    NotificationService notificationService,
  ) {
    return _buildSettingsCard(
      context,
      title: 'Paziņojumi',
      icon: Icons.notifications,
      children: [
        // Notification filters management
        ListTile(
          title: const Text('Paziņojumu filtri'),
          subtitle: Text(
            '${appState.notificationFilters.length} aktīvi filtri',
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _showNotificationFiltersDialog(context, appState),
        ),
        
        const Divider(),
        
        // Notification types preferences
        ...NotificationType.values.map(
          (type) => _buildNotificationTypeFilter(context, appState, type),
        ),
        
        const Divider(),
        
        // Clear all notifications option
        ListTile(
          title: const Text('Dzēst visus paziņojumus'),
          subtitle: const Text('Noņemt visus saglabātos paziņojumus'),
          trailing: const Icon(Icons.clear_all),
          onTap: () => _showClearNotificationsDialog(context, notificationService),
        ),
      ],
    );
  }

  /// Builds notification type filter toggle
  /// Individual control for notification categories
  Widget _buildNotificationTypeFilter(
    BuildContext context,
    AppStateProvider appState,
    NotificationType type,
  ) {
    final isActive = appState.notificationFilters.contains(type.name);
    
    return SwitchListTile(
      title: Text(type.displayName),
      subtitle: Text('Rādīt ${type.displayName.toLowerCase()} paziņojumus'),
      value: isActive,
      onChanged: (value) {
        if (value) {
          appState.addNotificationFilter(type.name);
        } else {
          appState.removeNotificationFilter(type.name);
        }
      },
      secondary: Icon(_getTypeIcon(type)),
    );
  }

  /// Gets icon for notification type
  /// Visual representation matching notification categories
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

  /// Builds language settings section
  /// Internationalization and localization options
  Widget _buildLanguageSection(BuildContext context, AppStateProvider appState) {
    return _buildSettingsCard(
      context,
      title: 'Valoda',
      icon: Icons.language,
      children: [
        // Language selection
        ListTile(
          title: const Text('Lietotnes valoda'),
          subtitle: Text(_getLanguageName(appState.selectedLanguage)),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _showLanguageDialog(context, appState),
        ),
      ],
    );
  }

  /// Gets display name for language code
  /// Human-readable language names
  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'lv':
        return 'Latviešu';
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      default:
        return languageCode.toUpperCase();
    }
  }

  /// Builds account and data settings section
  /// User account management and data options
  Widget _buildAccountSection(BuildContext context, AppStateProvider appState) {
    return _buildSettingsCard(
      context,
      title: 'Konts un dati',
      icon: Icons.account_circle,
      children: [
        // Current user display
        ListTile(
          title: const Text('Lietotājs'),
          subtitle: Text(appState.currentUserId ?? 'Nav pieteicies'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _showUserDialog(context, appState),
        ),
        
        const Divider(),
        
        // Data export option
        ListTile(
          title: const Text('Eksportēt datus'),
          subtitle: const Text('Saglabāt savus datus'),
          trailing: const Icon(Icons.download),
          onTap: () => _exportUserData(context),
        ),
        
        // Reset app data option
        ListTile(
          title: const Text('Atiestatīt lietotni'),
          subtitle: const Text('Dzēst visus datus un iestatījumus'),
          trailing: const Icon(Icons.restore),
          onTap: () => _showResetDialog(context, appState),
        ),
      ],
    );
  }

  /// Builds about and support section
  /// App information and help resources
  Widget _buildAboutSection(BuildContext context) {
    return _buildSettingsCard(
      context,
      title: 'Par lietotni',
      icon: Icons.info,
      children: [
        // App version info
        const ListTile(
          title: Text('Versija'),
          subtitle: Text('1.0.0+1'),
          trailing: Icon(Icons.info_outline),
        ),
        
        // Developer info
        const ListTile(
          title: Text('Izstrādātājs'),
          subtitle: Text('Family Copilot Team'),
          trailing: Icon(Icons.code),
        ),
        
        // GitHub Copilot integration info
        ListTile(
          title: const Text('GitHub Copilot'),
          subtitle: const Text('AI asistents kodēšanā'),
          trailing: const Icon(Icons.assistant),
          onTap: () => _showCopilotInfo(context),
        ),
        
        // Support contact
        ListTile(
          title: const Text('Atbalsts'),
          subtitle: const Text('Sazināties ar mūsu komandu'),
          trailing: const Icon(Icons.support),
          onTap: () => _contactSupport(context),
        ),
      ],
    );
  }

  /// Builds reusable settings card with consistent styling
  /// Standardized card layout for settings sections
  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  /// Shows notification filters management dialog
  /// Advanced filtering configuration interface
  void _showNotificationFiltersDialog(
    BuildContext context,
    AppStateProvider appState,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paziņojumu filtri'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Izvēlieties, kādus paziņojumus vēlaties redzēt.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ...NotificationType.values.map(
              (type) => CheckboxListTile(
                title: Text(type.displayName),
                value: appState.notificationFilters.contains(type.name),
                onChanged: (value) {
                  if (value == true) {
                    appState.addNotificationFilter(type.name);
                  } else {
                    appState.removeNotificationFilter(type.name);
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aizvērt'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.clearNotificationFilters();
              Navigator.of(context).pop();
            },
            child: const Text('Notīrīt visus'),
          ),
        ],
      ),
    );
  }

  /// Shows language selection dialog
  /// Language switching interface
  void _showLanguageDialog(BuildContext context, AppStateProvider appState) {
    final languages = ['lv', 'en', 'ru'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Izvēlieties valodu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map(
            (lang) => RadioListTile<String>(
              title: Text(_getLanguageName(lang)),
              value: lang,
              groupValue: appState.selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  appState.setLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Atcelt'),
          ),
        ],
      ),
    );
  }

  /// Shows user management dialog
  /// User account configuration
  void _showUserDialog(BuildContext context, AppStateProvider appState) {
    final controller = TextEditingController(text: appState.currentUserId ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lietotāja ID'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Ievadiet lietotāja ID',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Atcelt'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.setCurrentUser(
                controller.text.isEmpty ? null : controller.text,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Saglabāt'),
          ),
        ],
      ),
    );
  }

  /// Shows clear notifications confirmation dialog
  /// Bulk deletion confirmation
  void _showClearNotificationsDialog(
    BuildContext context,
    NotificationService service,
  ) {
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
              service.clearAllNotifications();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Visi paziņojumi tika dzēsti'),
                ),
              );
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

  /// Shows app reset confirmation dialog
  /// Complete app data reset
  void _showResetDialog(BuildContext context, AppStateProvider appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atiestatīt lietotni?'),
        content: const Text(
          'Šī darbība dzēsīs visus datus, iestatījumus un paziņojumus. '
          'Darbību nevarēs atcelt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Atcelt'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.resetAppState();
              context.read<NotificationService>().clearAllNotifications();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lietotne tika atiestatīta'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Atiestatīt'),
          ),
        ],
      ),
    );
  }

  /// Shows GitHub Copilot information dialog
  /// Information about AI coding assistant integration
  void _showCopilotInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('GitHub Copilot integrācija'),
        content: const Text(
          'Šī lietotne demonstrē GitHub Copilot labākās prakses:\n\n'
          '• Skaidri komentāri ar mērķiem\n'
          '• Konsekventas importu struktūras\n'
          '• Precīzi definēti uzdevumi\n'
          '• Paredzamu koda stilistiku\n\n'
          'Copilot mācās no šiem paraugiem un sniedz kvalitatīvākus ieteikumus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aizvērt'),
          ),
        ],
      ),
    );
  }

  /// Exports user data for backup
  /// Data portability feature
  void _exportUserData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Datu eksports būs pieejams nākamajā versijā'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Contacts support team
  /// User support channel
  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Atbalsts: support@familycopilot.lv'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}