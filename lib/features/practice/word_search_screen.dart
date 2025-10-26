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
  
  // Selection state
  List<List<int>> _selectedCells = [];
  bool _isDragging = false;
  final Map<String, List<List<int>>> _foundWordPositions = {};

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
    _foundWordPositions.clear();
    _selectedCells.clear();
    
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
    setState(() {
      _selectedCells = [[row, col]];
      _isDragging = true;
    });
  }

  void _onCellDragUpdate(int row, int col) {
    if (!_isDragging) return;
    
    setState(() {
      // Only add if it's a valid continuation (same row, column, or diagonal)
      if (_selectedCells.isNotEmpty) {
        final lastCell = _selectedCells.last;
        final rowDiff = (row - lastCell[0]).abs();
        final colDiff = (col - lastCell[1]).abs();
        
        // Check if it's adjacent and in the same direction
        if (rowDiff <= 1 && colDiff <= 1 && !_selectedCells.any((c) => c[0] == row && c[1] == col)) {
          _selectedCells.add([row, col]);
        }
      }
    });
  }

  void _onCellDragEnd() {
    if (!_isDragging) return;
    
    setState(() {
      _isDragging = false;
      _checkSelectedWord();
      _selectedCells.clear();
    });
  }

  void _checkSelectedWord() {
    if (_selectedCells.length < 2) return;
    
    // Get the selected word
    final selectedWord = _selectedCells.map((cell) => _grid[cell[0]][cell[1]]).join();
    final selectedWordReversed = selectedWord.split('').reversed.join();
    
    // Check if it matches any word to find
    for (final word in _wordsToFind) {
      if (!_foundWords.contains(word)) {
        final wordUpper = word.toUpperCase();
        if (selectedWord == wordUpper || selectedWordReversed == wordUpper) {
          _markWordAsFound(word);
          _foundWordPositions[word] = List.from(_selectedCells);
          break;
        }
      }
    }
  }

  void _markWordAsFound(String word) {
    if (!_foundWords.contains(word)) {
      setState(() {
        _foundWords.add(word);
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found: $word! 🎉'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
      
      // Check if all words are found
      if (_foundWords.length == _wordsToFind.length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _showCompletionDialog();
        });
      }
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations!'),
        content: const Text('You found all the words!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _generateWordSearch();
              });
            },
            child: const Text('New Game'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  bool _isCellSelected(int row, int col) {
    return _selectedCells.any((cell) => cell[0] == row && cell[1] == col);
  }

  bool _isCellFound(int row, int col) {
    for (final positions in _foundWordPositions.values) {
      if (positions.any((cell) => cell[0] == row && cell[1] == col)) {
        return true;
      }
    }
    return false;
  }

  List<int>? _getCellFromPosition(Offset position) {
    // Each cell is 28px + 2px margin = 30px total
    const cellSize = 30.0;
    
    final col = (position.dx / cellSize).floor();
    final row = (position.dy / cellSize).floor();
    
    // Validate the calculated position is within grid bounds
    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      return [row, col];
    }
    return null;
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isFound 
                                    ? Colors.green.withOpacity(0.2)
                                    : Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isFound ? Colors.green : Colors.transparent,
                                  width: isFound ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isFound)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 14,
                                        color: Colors.green,
                                      ),
                                    ),
                                  Text(
                                    word,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      decoration: isFound ? TextDecoration.lineThrough : null,
                                      color: isFound ? Colors.green.shade700 : null,
                                    ),
                                  ),
                                ],
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
                          child: GestureDetector(
                            onPanStart: (details) {
                              final cell = _getCellFromPosition(details.localPosition);
                              if (cell != null) {
                                _onCellTap(cell[0], cell[1]);
                              }
                            },
                            onPanUpdate: (details) {
                              final cell = _getCellFromPosition(details.localPosition);
                              if (cell != null) {
                                _onCellDragUpdate(cell[0], cell[1]);
                              }
                            },
                            onPanEnd: (_) => _onCellDragEnd(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: _grid.asMap().entries.map((rowEntry) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: rowEntry.value.asMap().entries.map((colEntry) {
                                    final row = rowEntry.key;
                                    final col = colEntry.key;
                                    final isSelected = _isCellSelected(row, col);
                                    final isFound = _isCellFound(row, col);
                                    
                                    return Container(
                                      width: 28,
                                      height: 28,
                                      margin: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: isFound
                                            ? Colors.green.withOpacity(0.3)
                                            : isSelected
                                                ? Colors.blue.withOpacity(0.3)
                                                : Theme.of(context).colorScheme.surface,
                                        border: Border.all(
                                          color: isFound
                                              ? Colors.green
                                              : isSelected
                                                  ? Colors.blue
                                                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                                          width: isFound || isSelected ? 2 : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          colEntry.value,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isFound
                                                ? Colors.green.shade900
                                                : isSelected
                                                    ? Colors.blue.shade900
                                                    : null,
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
                ),
                const SizedBox(height: 12),
                
                // Instructions
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.touch_app, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap and drag to select letters and find words!',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
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
