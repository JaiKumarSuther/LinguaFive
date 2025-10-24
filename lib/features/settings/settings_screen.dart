import 'package:flutter/material.dart';
import '../../data/language_data.dart';
import '../../services/user_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final language = await UserPreferences.getSelectedLanguage();
    final reminderEnabled = await UserPreferences.getDailyReminder();
    final reminderTimeStr = await UserPreferences.getReminderTime();
    
    setState(() {
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


