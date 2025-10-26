import 'package:flutter/material.dart';
import '../../data/language_data.dart';
import '../../services/user_preferences.dart';

class ReviewWordsScreen extends StatefulWidget {
  const ReviewWordsScreen({super.key});

  @override
  State<ReviewWordsScreen> createState() => _ReviewWordsScreenState();
}

class _ReviewWordsScreenState extends State<ReviewWordsScreen> {
  List<WordData> _wordData = [];
  int _currentIndex = 0;
  bool _showTranslation = false;
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
    if (languageData != null) {
      final wordData = learnedWords
          .map((word) => languageData.words.firstWhere(
                (w) => w.word == word,
                orElse: () => languageData.words.first,
              ))
          .toList();
      
      setState(() {
        _wordData = wordData;
        _isLoading = false;
      });
    }
  }

  void _nextWord() {
    if (_currentIndex < _wordData.length - 1) {
      setState(() {
        _currentIndex++;
        _showTranslation = false;
      });
    }
  }

  void _previousWord() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showTranslation = false;
      });
    }
  }

  void _toggleTranslation() {
    setState(() {
      _showTranslation = !_showTranslation;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_wordData.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Words')),
        body: const Center(
          child: Text('No words to review yet. Learn some words first!'),
        ),
      );
    }

    final currentWord = _wordData[_currentIndex];
    final progress = (_currentIndex + 1) / _wordData.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Words'),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Progress indicator
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_currentIndex + 1} / ${_wordData.length}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Word card
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Word
                          Text(
                            currentWord.word,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          
                          // Pronunciation
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              currentWord.pronunciation,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Translation (revealed on tap)
                          if (_showTranslation) ...[
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.green.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    currentWord.translation,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Examples
                                  if (currentWord.examples.isNotEmpty) ...[
                                    const Divider(),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Examples:',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...currentWord.examples.take(2).map((example) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text(
                                        '• $example',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                  ],
                                ],
                              ),
                            ),
                          ] else ...[
                            // Tap to reveal button
                            FilledButton.icon(
                              onPressed: _toggleTranslation,
                              icon: const Icon(Icons.visibility),
                              label: const Text('Show Translation'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Navigation buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _currentIndex > 0 ? _previousWord : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _currentIndex < _wordData.length - 1 ? _nextWord : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
