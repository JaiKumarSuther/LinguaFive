import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../data/language_data.dart';
import '../../services/user_preferences.dart';
import '../quiz/quiz_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  String? _selectedLanguage;
  List<WordData> _todayWords = [];
  List<String> _learnedWords = [];
  List<String> _lastQuizResults = [];
  bool _isLoading = true;
  bool _showOnlyLearned = false;

  @override
  void initState() {
    super.initState();
    _loadTodayWords();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh learned words when returning from any screen
    _refreshLearnedWords();
  }

  @override
  void didUpdateWidget(TodayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh data when widget updates (e.g., language change)
    _refreshLearnedWords();
  }

  Future<void> _refreshLearnedWords() async {
    final learnedWords = await UserPreferences.getLearnedWords();
    final lastQuizResults = await UserPreferences.getLastQuizSessionResults();
    final currentLanguage = await UserPreferences.getSelectedLanguage();
    
    if (mounted) {
      setState(() {
        _learnedWords = learnedWords;
        _lastQuizResults = lastQuizResults;
        
        // If language changed, reload today's words
        if (currentLanguage != _selectedLanguage) {
          _selectedLanguage = currentLanguage;
          _todayWords = LanguageRepository.getWordsForLanguage(currentLanguage ?? 'spanish', limit: 5);
        }
      });
    }
  }

  List<WordData> get _filteredWords {
    if (_showOnlyLearned) {
      return _todayWords.where((word) => _lastQuizResults.contains(word.word)).toList();
    }
    return _todayWords;
  }

  Future<void> _loadTodayWords() async {
    final language = await UserPreferences.getSelectedLanguage();
    final learnedWords = await UserPreferences.getLearnedWords();
    final lastQuizResults = await UserPreferences.getLastQuizSessionResults();
    setState(() {
      _selectedLanguage = language;
      _todayWords = LanguageRepository.getWordsForLanguage(language ?? 'spanish', limit: 5);
      _learnedWords = learnedWords;
      _lastQuizResults = lastQuizResults;
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

    final language = LanguageRepository.getLanguage(_selectedLanguage ?? 'spanish');

    return Scaffold(
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
          child: Column(
            children: [
              // Header - Flexible to prevent overflow
              Flexible(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width > 600 ? 20 : 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width > 600 ? 12 : 10,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              language?.flag ?? '🌍',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width > 600 ? 24 : 20,
                              ),
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width > 600 ? 16 : 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today's 5 Words",
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width > 600 ? null : 20,
                                  ),
                                ),
                                Text(
                                  language?.name ?? 'Spanish',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontSize: MediaQuery.of(context).size.width > 600 ? null : 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Status badges - wrap to multiple lines if needed
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Toggle Button
                          Container(
                            decoration: BoxDecoration(
                              color: _showOnlyLearned 
                                  ? Colors.green.withOpacity(0.1)
                                  : Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _showOnlyLearned 
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                setState(() {
                                  _showOnlyLearned = !_showOnlyLearned;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _showOnlyLearned ? Icons.check_circle : Icons.visibility,
                                      size: 16,
                                      color: _showOnlyLearned 
                                          ? Colors.green
                                          : Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _showOnlyLearned ? 'Learned' : 'All',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _showOnlyLearned 
                                            ? Colors.green
                                            : Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_filteredWords.length}/${_todayWords.length}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_learnedWords.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_learnedWords.length} marked',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          if (_lastQuizResults.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_lastQuizResults.length} learned',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: _showOnlyLearned 
                            ? _lastQuizResults.length / 5
                            : _todayWords.length / 5,
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _showOnlyLearned 
                              ? Colors.green
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Quiz Button - only show when all 5 words are learned
              if (_learnedWords.length >= 5)
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const QuizScreen(),
                          ),
                        ).then((_) {
                          // Refresh data when returning from quiz
                          _refreshLearnedWords();
                        }),
                        icon: const Icon(Icons.quiz),
                        label: const Text('Take Quiz'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else if (_learnedWords.isNotEmpty)
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Learn all 5 words to unlock quiz',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              // Words List
              Expanded(
                child: _filteredWords.isEmpty && _showOnlyLearned
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
                              'No learned words yet',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Take the quiz to verify your learning!',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredWords.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final word = _filteredWords[index];
                          final originalIndex = _todayWords.indexOf(word);
                          return _buildWordCard(context, word, originalIndex);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWordCard(BuildContext context, WordData word, int index) {
    final isMarked = _learnedWords.contains(word.word);
    final isLearned = _lastQuizResults.contains(word.word); // Only learned if in last quiz results
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).pushNamed(
          AppRoutes.wordDetails,
          arguments: {
            'word': word.word,
            'translation': word.translation,
            'pronunciation': word.pronunciation,
            'examples': word.examples,
          },
        ),
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width > 600 ? 16 : 12,
          ),
          child: Row(
            children: [
              // Word number or status indicator
              Container(
                width: MediaQuery.of(context).size.width > 600 ? 40 : 36,
                height: MediaQuery.of(context).size.width > 600 ? 40 : 36,
                decoration: BoxDecoration(
                  color: isLearned 
                      ? Colors.green.withOpacity(0.1)
                      : isMarked 
                          ? Colors.orange.withOpacity(0.1)
                          : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isLearned
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: MediaQuery.of(context).size.width > 600 ? 24 : 20,
                        )
                      : isMarked
                          ? Icon(
                              Icons.bookmark,
                              color: Colors.orange,
                              size: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: MediaQuery.of(context).size.width > 600 ? null : 14,
                              ),
                            ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width > 600 ? 16 : 12),
              
              // Word content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            word.word,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: isLearned ? TextDecoration.lineThrough : null,
                              color: isLearned 
                                  ? Theme.of(context).colorScheme.onSurfaceVariant
                                  : null,
                              fontSize: MediaQuery.of(context).size.width > 600 ? null : 18,
                            ),
                          ),
                        ),
                        if (isLearned)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width > 600 ? 6 : 4,
                              vertical: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'LEARNED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width > 600 ? 8 : 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else if (isMarked)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width > 600 ? 6 : 4,
                              vertical: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'MARKED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width > 600 ? 8 : 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width > 600 ? 4 : 3),
                    Text(
                      word.translation,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: MediaQuery.of(context).size.width > 600 ? null : 15,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width > 600 ? 4 : 3),
                    Row(
                      children: [
                        Icon(
                          Icons.record_voice_over,
                          size: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width > 600 ? 4 : 3),
                        Flexible(
                          child: Text(
                            word.pronunciation,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: MediaQuery.of(context).size.width > 600 ? null : 12,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Difficulty badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(word.difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  word.difficulty.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(word.difficulty),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Chevron
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}


