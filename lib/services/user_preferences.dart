import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _selectedLanguageKey = 'selected_language';
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _dailyReminderKey = 'daily_reminder';
  static const String _reminderTimeKey = 'reminder_time';
  static const String _learnedWordsKey = 'learned_words';
  static const String _quizVerifiedWordsKey = 'quiz_verified_words';
  static const String _lastQuizSessionKey = 'last_quiz_session';
  static const String _quizSessionResultsKey = 'quiz_session_results';
  static const String _dailyProgressKey = 'daily_progress';
  static const String _allLearnedWordsKey = 'all_learned_words';

  static Future<void> setSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguageKey, languageCode);
  }

  static Future<String?> getSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedLanguageKey);
  }

  static Future<void> setUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setDailyReminder(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyReminderKey, enabled);
  }

  static Future<bool> getDailyReminder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dailyReminderKey) ?? true;
  }

  static Future<void> setReminderTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reminderTimeKey, time);
  }

  static Future<String?> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_reminderTimeKey);
  }

  static Future<void> addLearnedWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final learnedWords = await getLearnedWords();
    if (!learnedWords.contains(word)) {
      learnedWords.add(word);
      await prefs.setStringList(_learnedWordsKey, learnedWords);
    }
  }

  static Future<List<String>> getLearnedWords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_learnedWordsKey) ?? [];
  }

  static Future<bool> isWordLearned(String word) async {
    final learnedWords = await getLearnedWords();
    return learnedWords.contains(word);
  }

  static Future<void> removeLearnedWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final learnedWords = await getLearnedWords();
    learnedWords.remove(word);
    await prefs.setStringList(_learnedWordsKey, learnedWords);
  }

  static Future<int> getLearnedWordsCount() async {
    final learnedWords = await getLearnedWords();
    return learnedWords.length;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_learnedWordsKey);
    await prefs.remove(_quizVerifiedWordsKey);
  }

  // Quiz-verified words methods
  static Future<void> addQuizVerifiedWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final quizVerifiedWords = await getQuizVerifiedWords();
    if (!quizVerifiedWords.contains(word)) {
      quizVerifiedWords.add(word);
      await prefs.setStringList(_quizVerifiedWordsKey, quizVerifiedWords);
    }
  }

  static Future<List<String>> getQuizVerifiedWords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_quizVerifiedWordsKey) ?? [];
  }

  static Future<bool> isWordQuizVerified(String word) async {
    final quizVerifiedWords = await getQuizVerifiedWords();
    return quizVerifiedWords.contains(word);
  }

  static Future<void> clearQuizVerifiedWords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_quizVerifiedWordsKey);
  }

  static Future<int> getQuizVerifiedWordsCount() async {
    final quizVerifiedWords = await getQuizVerifiedWords();
    return quizVerifiedWords.length;
  }

  // Quiz session management
  static Future<void> saveQuizSessionResults(List<String> correctlyAnsweredWords) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Save the session ID
    await prefs.setString(_lastQuizSessionKey, sessionId);
    
    // Save the results for this session
    await prefs.setStringList('${_quizSessionResultsKey}_$sessionId', correctlyAnsweredWords);
  }

  static Future<List<String>> getLastQuizSessionResults() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSessionId = prefs.getString(_lastQuizSessionKey);
    
    if (lastSessionId == null) {
      return [];
    }
    
    return prefs.getStringList('${_quizSessionResultsKey}_$lastSessionId') ?? [];
  }

  static Future<void> clearAllQuizSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastQuizSessionKey);
    await prefs.remove(_quizVerifiedWordsKey);
    
    // Clear all session result keys
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith(_quizSessionResultsKey)) {
        await prefs.remove(key);
      }
    }
  }

  // Clear all learning data when language changes
  static Future<void> clearAllLearningData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_learnedWordsKey);
    await prefs.remove(_quizVerifiedWordsKey);
    await prefs.remove(_lastQuizSessionKey);
    await prefs.remove(_dailyProgressKey);
    await prefs.remove(_allLearnedWordsKey);
    
    // Clear all session result keys
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith(_quizSessionResultsKey)) {
        await prefs.remove(key);
      }
    }
  }

  // Daily progress tracking
  static Future<void> saveDailyProgress(List<String> learnedWords) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format
    
    // Get existing daily progress
    final dailyProgress = await getDailyProgress();
    dailyProgress[today] = learnedWords;
    
    // Save updated progress
    final progressJson = dailyProgress.entries
        .map((e) => '${e.key}:${e.value.join(',')}')
        .join('|');
    await prefs.setString(_dailyProgressKey, progressJson);
    
    // Update all learned words
    await _updateAllLearnedWords();
  }

  static Future<Map<String, List<String>>> getDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressString = prefs.getString(_dailyProgressKey) ?? '';
    
    if (progressString.isEmpty) return {};
    
    final Map<String, List<String>> progress = {};
    final entries = progressString.split('|');
    
    for (final entry in entries) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        progress[parts[0]] = parts[1].isEmpty ? [] : parts[1].split(',');
      }
    }
    
    return progress;
  }

  static Future<List<String>> getAllLearnedWords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_allLearnedWordsKey) ?? [];
  }

  static Future<int> getTotalLearnedWordsCount() async {
    final allLearned = await getAllLearnedWords();
    return allLearned.length;
  }

  static Future<int> getCurrentStreak() async {
    final progress = await getDailyProgress();
    final today = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 365; i++) { // Check up to 1 year back
      final date = today.subtract(Duration(days: i));
      final dateString = date.toIso8601String().split('T')[0];
      
      if (progress.containsKey(dateString) && progress[dateString]!.isNotEmpty) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }

  static Future<int> getWordsLearnedToday() async {
    final progress = await getDailyProgress();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return progress[today]?.length ?? 0;
  }

  static Future<void> _updateAllLearnedWords() async {
    final prefs = await SharedPreferences.getInstance();
    final progress = await getDailyProgress();
    final allWords = <String>{};
    
    for (final words in progress.values) {
      allWords.addAll(words);
    }
    
    await prefs.setStringList(_allLearnedWordsKey, allWords.toList());
  }
}
