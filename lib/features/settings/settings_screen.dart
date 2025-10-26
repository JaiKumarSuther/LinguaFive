import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/language_data.dart';
import '../../services/user_preferences.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  String? _selectedLanguage;
  bool _langOpen = false;
  bool _reminderOpen = false;
  bool _isLoading = true;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final language = await UserPreferences.getSelectedLanguage();
    final reminderEnabled = await UserPreferences.getDailyReminder();
    final reminderTimeStr = await UserPreferences.getReminderTime();
    final user = AuthService.getCurrentUser();
    
    setState(() {
      _currentUser = user;
      _selectedLanguage = language;
      _reminderEnabled = reminderEnabled;
      if (reminderTimeStr != null) {
        final parts = reminderTimeStr.split(':');
        _reminderTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
      _isLoading = false;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _reminderTime);
    if (picked != null) {
      setState(() => _reminderTime = picked);
      await UserPreferences.setReminderTime('${picked.hour}:${picked.minute}');
    }
  }

  Future<void> _updateLanguage(String? newLanguage) async {
    if (newLanguage != null && newLanguage != _selectedLanguage) {
      // Clear all learning data when language changes
      await UserPreferences.clearAllLearningData();
      
      setState(() => _selectedLanguage = newLanguage);
      await UserPreferences.setSelectedLanguage(newLanguage);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Language changed! Learning progress has been reset.'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  Future<void> _updateReminder(bool enabled) async {
    setState(() => _reminderEnabled = enabled);
    await UserPreferences.setDailyReminder(enabled);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentLanguage = LanguageRepository.getLanguage(_selectedLanguage ?? 'spanish');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width > 600 ? 20 : 16,
            ),
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.settings,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Settings',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Customize your learning experience',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // User Profile Section
              if (_currentUser != null)
                _buildUserProfileCard(context, _currentUser!),
              
              if (_currentUser != null) const SizedBox(height: 16),
              
              // Language Preference Section
              _buildSectionCard(
                context,
                'Language Preference',
                Icons.language,
                [
                  ListTile(
                    title: const Text('Learning Language'),
                    subtitle: Row(
                      children: [
                        Text(currentLanguage?.flag ?? '🌍', style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(currentLanguage?.name ?? 'Spanish'),
                      ],
                    ),
                    trailing: Icon(_langOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    onTap: () => setState(() => _langOpen = !_langOpen),
                  ),
                  if (_langOpen)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: DropdownButtonFormField<String>(
                        value: _selectedLanguage,
                        decoration: InputDecoration(
                          labelText: 'Select Language',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                        items: LanguageRepository.availableLanguages.map((langCode) {
                          final language = LanguageRepository.getLanguage(langCode);
                          return DropdownMenuItem(
                            value: langCode,
                            child: Row(
                              children: [
                                Text(language?.flag ?? '🌍', style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Text(language?.name ?? langCode),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: _updateLanguage,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Notifications Section
              _buildSectionCard(
                context,
                'Notifications',
                Icons.notifications,
                [
                  SwitchListTile(
                    title: const Text('Daily Reminder'),
                    subtitle: const Text('Get reminded to practice daily'),
                    value: _reminderEnabled,
                    onChanged: _updateReminder,
                  ),
                  ListTile(
                    title: const Text('Reminder Time'),
                    subtitle: Text(_reminderTime.format(context)),
                    trailing: Icon(_reminderOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    onTap: () => setState(() => _reminderOpen = !_reminderOpen),
                  ),
                  if (_reminderOpen)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: FilledButton.icon(
                        onPressed: _reminderEnabled ? _pickTime : null,
                        icon: const Icon(Icons.access_time),
                        label: const Text('Pick time'),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Account Section
              _buildSectionCard(
                context,
                'Account',
                Icons.person,
                [
                  ListTile(
                    title: const Text('Logout'),
                    subtitle: const Text('Sign out of your account'),
                    trailing: const Icon(Icons.logout),
                    onTap: () async {
                      await UserPreferences.logout();
                      if (mounted) {
                        Navigator.of(context).pushReplacementNamed('/auth');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context, UserModel user) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            Divider(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2)),
            const SizedBox(height: 16),
            
            // User Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.local_fire_department,
                    '${user.currentStreak}',
                    'Day Streak',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.checklist_rtl,
                    '${user.totalLearnedWords}',
                    'Words Learned',
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Account Details
            _buildDetailRow(
              context,
              Icons.calendar_today,
              'Joined',
              dateFormat.format(user.createdAt),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              Icons.login,
              'Last Login',
              timeFormat.format(user.lastLoginAt),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              Icons.language,
              'Learning Language',
              LanguageRepository.getLanguage(user.selectedLanguage)?.name ?? user.selectedLanguage,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              Icons.badge,
              'User ID',
              user.id.substring(0, 8).toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
}


