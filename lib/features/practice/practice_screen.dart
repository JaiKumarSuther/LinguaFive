import 'package:flutter/material.dart';
import '../../data/language_data.dart';
import '../../services/user_preferences.dart';
import '../quiz/quiz_screen.dart';
import 'review_words_screen.dart';
import 'flash_cards_screen.dart';
import 'word_search_screen.dart';
import 'pronunciation_screen.dart';
import 'daily_challenge_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  String? _selectedLanguage;
  List<String> _learnedWords = [];
  List<String> _allWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final language = await UserPreferences.getSelectedLanguage();
    final learnedWords = await UserPreferences.getLearnedWords();
    
    final languageData = LanguageRepository.getLanguage(language ?? 'spanish');
    final allWords = languageData?.words.map((w) => w.word).toList() ?? [];
    
    setState(() {
      _selectedLanguage = language;
      _learnedWords = learnedWords;
      _allWords = allWords;
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
    if (languageData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice')),
        body: const Center(child: Text('Language not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                // Header
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                                'Practice & Review',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                const SizedBox(height: 24),
                
                // Practice Activities
                Text(
                  'Practice Activities',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                    crossAxisSpacing: MediaQuery.of(context).size.width > 600 ? 16 : 12,
                    mainAxisSpacing: MediaQuery.of(context).size.width > 600 ? 16 : 12,
                    children: [
                      _buildPracticeCard(
                        context,
                        'Quick Quiz',
                        'Test your knowledge',
                        Icons.quiz,
                        Colors.purple,
                        _learnedWords.length >= 5,
                        () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const QuizScreen(),
                          ),
                        ),
                      ),
                      _buildPracticeCard(
                        context,
                        'Review Words',
                        'Go through learned words',
                        Icons.school,
                        Colors.blue,
                        _learnedWords.isNotEmpty,
                        () => _showReviewWords(context),
                      ),
                      _buildPracticeCard(
                        context,
                        'Flash Cards',
                        'Quick word practice',
                        Icons.style,
                        Colors.green,
                        _learnedWords.isNotEmpty,
                        () => _showFlashCards(context),
                      ),
                      _buildPracticeCard(
                        context,
                        'Word Search',
                        'Find words in grid',
                        Icons.grid_view,
                        Colors.orange,
                        _allWords.length >= 10,
                        () => _showWordSearch(context),
                      ),
                      _buildPracticeCard(
                        context,
                        'Pronunciation',
                        'Practice speaking',
                        Icons.record_voice_over,
                        Colors.red,
                        _learnedWords.isNotEmpty,
                        () => _showPronunciation(context),
                      ),
                      _buildPracticeCard(
                        context,
                        'Daily Challenge',
                        'Complete daily goals',
                        Icons.emoji_events,
                        Colors.amber,
                        true,
                        () => _showDailyChallenge(context),
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

  Widget _buildPracticeCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isEnabled,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isEnabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width > 600 ? 16 : 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isEnabled 
                ? color.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width > 600 ? 12 : 10,
                ),
                decoration: BoxDecoration(
                  color: isEnabled 
                      ? color.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: MediaQuery.of(context).size.width > 600 ? 32 : 28,
                  color: isEnabled ? color : Colors.grey,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width > 600 ? 12 : 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isEnabled ? null : Colors.grey,
                  fontSize: MediaQuery.of(context).size.width > 600 ? null : 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isEnabled 
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isEnabled) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Locked',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewWords(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ReviewWordsScreen(),
      ),
    );
  }

  void _showFlashCards(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FlashCardsScreen(),
      ),
    );
  }

  void _showWordSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WordSearchScreen(),
      ),
    );
  }

  void _showPronunciation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PronunciationScreen(),
      ),
    );
  }

  void _showDailyChallenge(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DailyChallengeScreen(),
      ),
    );
  }
}
