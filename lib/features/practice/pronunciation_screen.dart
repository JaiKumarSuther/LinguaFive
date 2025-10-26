import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../data/language_data.dart';
import '../../services/user_preferences.dart';

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  List<WordData> _wordData = [];
  int _currentIndex = 0;
  bool _showPronunciation = false;
  bool _isLoading = true;
  FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadData();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage(_getLanguageCode());
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });
    
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
    
    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  String _getLanguageCode() {
    // Use selected language from user preferences
    switch (_selectedLanguage?.toLowerCase()) {
      case 'spanish':
        return 'es-ES';
      case 'french':
        return 'fr-FR';
      case 'german':
        return 'de-DE';
      case 'italian':
        return 'it-IT';
      case 'japanese':
        return 'ja-JP';
      case 'chinese':
        return 'zh-CN';
      default:
        return 'en-US';
    }
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
      
      // Shuffle for variety
      wordData.shuffle();
      
      setState(() {
        _selectedLanguage = language;
        _wordData = wordData;
        _isLoading = false;
      });
    }
  }

  void _nextWord() {
    if (_currentIndex < _wordData.length - 1) {
      setState(() {
        _currentIndex++;
        _showPronunciation = false;
      });
    }
  }

  void _previousWord() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showPronunciation = false;
      });
    }
  }

  void _togglePronunciation() {
    setState(() {
      _showPronunciation = !_showPronunciation;
    });
  }

  Future<void> _speakWord() async {
    if (_wordData.isNotEmpty) {
      final currentWord = _wordData[_currentIndex];
      await _flutterTts.setLanguage(_getLanguageCode());
      await _flutterTts.speak(currentWord.word);
    }
  }

  Future<void> _speakTranslation() async {
    if (_wordData.isNotEmpty) {
      final currentWord = _wordData[_currentIndex];
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.speak(currentWord.translation);
    }
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
        appBar: AppBar(title: const Text('Pronunciation Practice')),
        body: const Center(
          child: Text('No words to practice yet. Learn some words first!'),
        ),
      );
    }

    final currentWord = _wordData[_currentIndex];
    final progress = (_currentIndex + 1) / _wordData.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Practice'),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress indicator
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pronunciation Practice',
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
                        const SizedBox(height: 6),
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
                const SizedBox(height: 16),
                
                // Main practice area
                Expanded(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Microphone icon
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.mic,
                                size: 48,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Word to pronounce
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    currentWord.word,
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  onPressed: _isSpeaking ? null : _speakWord,
                                  icon: Icon(
                                    _isSpeaking ? Icons.volume_up : Icons.volume_up,
                                    color: _isSpeaking ? Colors.grey : Theme.of(context).colorScheme.primary,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: _isSpeaking 
                                        ? Colors.grey.withOpacity(0.1)
                                        : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            // Translation
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      currentWord.translation,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: _isSpeaking ? null : _speakTranslation,
                                  icon: Icon(
                                    Icons.translate,
                                    color: _isSpeaking ? Colors.grey : Colors.blue,
                                    size: 20,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: _isSpeaking 
                                        ? Colors.grey.withOpacity(0.1)
                                        : Colors.blue.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // Pronunciation guide
                            if (_showPronunciation) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                                ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.volume_up,
                                            size: 28,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              currentWord.pronunciation,
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                          onPressed: _isSpeaking ? null : _speakWord,
                                          icon: Icon(
                                            _isSpeaking ? Icons.volume_off : Icons.play_arrow,
                                            color: _isSpeaking ? Colors.grey : Colors.green,
                                            size: 24,
                                          ),
                                          style: IconButton.styleFrom(
                                            backgroundColor: _isSpeaking 
                                                ? Colors.grey.withOpacity(0.1)
                                                : Colors.green.withOpacity(0.1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Listen and repeat',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              FilledButton.icon(
                                onPressed: _togglePronunciation,
                                icon: const Icon(Icons.volume_up, size: 18),
                                label: const Text('Show Pronunciation'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            
                            // Practice tips
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Practice Tips:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '• Speak slowly and clearly\n• Break down difficult sounds\n• Repeat multiple times\n• Record yourself if possible',
                                    style: Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Navigation buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _currentIndex > 0 ? _previousWord : null,
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('Previous'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _currentIndex < _wordData.length - 1 ? _nextWord : null,
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: const Text('Next'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
