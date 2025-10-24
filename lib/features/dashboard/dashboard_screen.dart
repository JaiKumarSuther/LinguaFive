import 'package:flutter/material.dart';
import '../../services/user_preferences.dart';
import '../../data/language_data.dart';
import '../learned/learned_words_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _streak = 0;
  int _totalWords = 0;
  int _wordsToday = 0;
  int _daysActive = 0;
  String? _selectedLanguage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final streak = await UserPreferences.getCurrentStreak();
    final totalWords = await UserPreferences.getTotalLearnedWordsCount();
    final wordsToday = await UserPreferences.getWordsLearnedToday();
    final dailyProgress = await UserPreferences.getDailyProgress();
    final language = await UserPreferences.getSelectedLanguage();
    
    setState(() {
      _streak = streak;
      _totalWords = totalWords;
      _wordsToday = wordsToday;
      _daysActive = dailyProgress.length;
      _selectedLanguage = language;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final languageData = LanguageRepository.getLanguage(_selectedLanguage ?? 'spanish');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LearnedWordsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.list),
            tooltip: 'View All Learned Words',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width > 600 ? 20 : 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language header
                if (languageData != null)
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            languageData.flag,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Learning Progress',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  languageData.name,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                
                // Stats cards
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Streak',
                        value: '$_streak🔥',
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width > 600 ? 12 : 8),
                    Expanded(
                      child: _StatCard(
                        title: 'Total',
                        value: '$_totalWords📚',
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.width > 600 ? 12 : 8),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Today',
                        value: '$_wordsToday✅',
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width > 600 ? 12 : 8),
                    Expanded(
                      child: _StatCard(
                        title: 'Days Active',
                        value: '$_daysActive📅',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // View all learned words button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LearnedWordsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.school),
                    label: const Text('View All Learned Words'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Recent activity placeholder
                Text(
                  'Keep Learning!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _totalWords == 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Start your learning journey!',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Mark words as learned and take quizzes to see your progress here.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          children: [
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.trending_up, color: Colors.green),
                                ),
                                title: const Text('Great Progress!'),
                                subtitle: Text('You\'ve learned $_totalWords words so far'),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.local_fire_department, color: Colors.orange),
                                ),
                                title: const Text('Current Streak'),
                                subtitle: Text('$_streak days in a row!'),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width > 600 ? 16 : 12,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: MediaQuery.of(context).size.width > 600 ? null : 12,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width > 600 ? 8 : 6),
          Text(
            value, 
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width > 600 ? null : 18,
            ),
          ),
        ],
      ),
    );
  }
}


