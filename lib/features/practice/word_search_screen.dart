import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/language_data.dart';
import '../../services/user_preferences.dart';

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({super.key});

  @override
  State<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  List<String> _allWords = [];
  List<List<String>> _grid = [];
  List<String> _wordsToFind = [];
  final List<String> _foundWords = [];
  bool _isLoading = true;
  static const int gridSize = 10;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final language = await UserPreferences.getSelectedLanguage();
    final languageData = LanguageRepository.getLanguage(language ?? 'spanish');
    
    if (languageData != null) {
      final allWords = languageData.words.map((w) => w.word).toList();
      
      setState(() {
        _allWords = allWords;
        _generateWordSearch();
        _isLoading = false;
      });
    }
  }

  void _generateWordSearch() {
    // Select 6 random words to find
    final shuffledWords = List<String>.from(_allWords)..shuffle();
    _wordsToFind = shuffledWords.take(6).toList();
    _foundWords.clear();
    
    // Create empty grid
    _grid = List.generate(gridSize, (_) => List.filled(gridSize, ''));
    
    // Place words in grid
    _placeWordsInGrid();
    
    // Fill remaining spaces with random letters
    _fillEmptySpaces();
  }

  void _placeWordsInGrid() {
    final random = Random();
    
    for (final word in _wordsToFind) {
      bool placed = false;
      int attempts = 0;
      
      while (!placed && attempts < 100) {
        final row = random.nextInt(gridSize);
        final col = random.nextInt(gridSize);
        final direction = random.nextInt(4); // 0: horizontal, 1: vertical, 2: diagonal down-right, 3: diagonal down-left
        
        if (_canPlaceWord(word, row, col, direction)) {
          _placeWord(word, row, col, direction);
          placed = true;
        }
        attempts++;
      }
    }
  }

  bool _canPlaceWord(String word, int row, int col, int direction) {
    for (int i = 0; i < word.length; i++) {
      int newRow = row;
      int newCol = col;
      
      switch (direction) {
        case 0: // horizontal
          newCol = col + i;
          break;
        case 1: // vertical
          newRow = row + i;
          break;
        case 2: // diagonal down-right
          newRow = row + i;
          newCol = col + i;
          break;
        case 3: // diagonal down-left
          newRow = row + i;
          newCol = col - i;
          break;
      }
      
      if (newRow >= gridSize || newCol >= gridSize || newCol < 0) {
        return false;
      }
      
      if (_grid[newRow][newCol].isNotEmpty && _grid[newRow][newCol] != word[i]) {
        return false;
      }
    }
    return true;
  }

  void _placeWord(String word, int row, int col, int direction) {
    for (int i = 0; i < word.length; i++) {
      int newRow = row;
      int newCol = col;
      
      switch (direction) {
        case 0: // horizontal
          newCol = col + i;
          break;
        case 1: // vertical
          newRow = row + i;
          break;
        case 2: // diagonal down-right
          newRow = row + i;
          newCol = col + i;
          break;
        case 3: // diagonal down-left
          newRow = row + i;
          newCol = col - i;
          break;
      }
      
      _grid[newRow][newCol] = word[i].toUpperCase();
    }
  }

  void _fillEmptySpaces() {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (_grid[i][j].isEmpty) {
          _grid[i][j] = letters[random.nextInt(letters.length)];
        }
      }
    }
  }

  void _onCellTap(int row, int col) {
    // Simple tap to find words - in a real implementation, you'd have selection logic
    setState(() {
      // For demo purposes, just mark as found when tapped
      // In a real game, you'd implement proper word selection
    });
  }

  void _markWordAsFound(String word) {
    if (!_foundWords.contains(word)) {
      setState(() {
        _foundWords.add(word);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Search'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _generateWordSearch,
            icon: const Icon(Icons.refresh),
            tooltip: 'New Game',
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Instructions and progress
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Find the words in the grid!',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Found: ${_foundWords.length} / ${_wordsToFind.length}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Word list
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Words to find:',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 3,
                          children: _wordsToFind.map((word) {
                            final isFound = _foundWords.contains(word);
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: isFound 
                                    ? Colors.green.withOpacity(0.2)
                                    : Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isFound ? Colors.green : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                word,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  decoration: isFound ? TextDecoration.lineThrough : null,
                                  color: isFound ? Colors.green : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Word search grid
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _grid.asMap().entries.map((rowEntry) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: rowEntry.value.asMap().entries.map((colEntry) {
                                  return GestureDetector(
                                    onTap: () => _onCellTap(rowEntry.key, colEntry.key),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      margin: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          colEntry.value,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Demo buttons (in a real game, these would be replaced by proper selection logic)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (_foundWords.length < _wordsToFind.length) {
                            final nextWord = _wordsToFind.firstWhere(
                              (word) => !_foundWords.contains(word),
                              orElse: () => _wordsToFind.first,
                            );
                            _markWordAsFound(nextWord);
                          }
                        },
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text('Find Next'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _generateWordSearch,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('New Game'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
