import '../models/user_model.dart';
import 'auth_service.dart';

class UserPreferences {
  // Get current user
  static UserModel? _getCurrentUser() {
    return AuthService.getCurrentUser();
  }

  // Language
  static Future<void> setSelectedLanguage(String languageCode) async {
    final user = _getCurrentUser();
    if (user != null) {
      user.selectedLanguage = languageCode;
      await AuthService.updateUser(user);
    }
  }

  static Future<String?> getSelectedLanguage() async {
    final user = _getCurrentUser();
    return user?.selectedLanguage;
  }

  // User info
  static Future<String?> getUserEmail() async {
    final user = _getCurrentUser();
    return user?.email;
  }

  static Future<bool> isLoggedIn() async {
    return AuthService.isLoggedIn();
  }

  // Daily reminder
  static Future<void> setDailyReminder(bool enabled) async {
    final user = _getCurrentUser();
    if (user != null) {
      user.dailyReminder = enabled;
      await AuthService.updateUser(user);
    }
  }

  static Future<bool> getDailyReminder() async {
    final user = _getCurrentUser();
    return user?.dailyReminder ?? true;
  }

  static Future<void> setReminderTime(String time) async {
    final user = _getCurrentUser();
    if (user != null) {
      user.reminderTime = time;
      await AuthService.updateUser(user);
    }
  }

  static Future<String?> getReminderTime() async {
    final user = _getCurrentUser();
    return user?.reminderTime;
  }

  // Learned words (marked by user, not quiz-verified)
  static Future<void> addLearnedWord(String word) async {
    final user = _getCurrentUser();
    if (user != null && !user.learnedWords.contains(word)) {
      user.learnedWords.add(word);
      await AuthService.updateUser(user);
    }
  }

  static Future<List<String>> getLearnedWords() async {
    final user = _getCurrentUser();
    return user?.learnedWords ?? [];
  }

  static Future<bool> isWordLearned(String word) async {
    final user = _getCurrentUser();
    return user?.learnedWords.contains(word) ?? false;
  }

  static Future<void> removeLearnedWord(String word) async {
    final user = _getCurrentUser();
    if (user != null) {
      user.learnedWords.remove(word);
      await AuthService.updateUser(user);
    }
  }

  static Future<int> getLearnedWordsCount() async {
    final user = _getCurrentUser();
    return user?.learnedWords.length ?? 0;
  }

  // Logout
  static Future<void> logout() async {
    await AuthService.logout();
  }

  // Quiz-verified words (words that passed quiz)
  static Future<List<String>> getQuizVerifiedWords() async {
    // Quiz verified words are stored in allLearnedWords
    return getAllLearnedWords();
  }

  static Future<bool> isWordQuizVerified(String word) async {
    final user = _getCurrentUser();
    return user?.allLearnedWords.contains(word) ?? false;
  }

  // Quiz session management
  static Future<void> saveQuizSessionResults(List<String> correctlyAnsweredWords) async {
    final user = _getCurrentUser();
    if (user != null) {
      user.lastQuizResults = correctlyAnsweredWords;
      await AuthService.updateUser(user);
    }
  }

  static Future<List<String>> getLastQuizSessionResults() async {
    final user = _getCurrentUser();
    return user?.lastQuizResults ?? [];
  }

  // Clear all learning data when language changes
  static Future<void> clearAllLearningData() async {
    final user = _getCurrentUser();
    if (user != null) {
      user.learnedWords = [];
      user.allLearnedWords = [];
      user.lastQuizResults = [];
      user.dailyProgress = {};
      user.currentStreak = 0;
      user.totalLearnedWords = 0;
      await AuthService.updateUser(user);
    }
  }

  // Daily progress tracking
  static Future<void> saveDailyProgress(List<String> learnedWords) async {
    final user = _getCurrentUser();
    if (user != null) {
      final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format
      
      // Update daily progress
      user.dailyProgress[today] = learnedWords;
      
      // Update all learned words with quiz-verified words
      final allWords = <String>{};
      for (final words in user.dailyProgress.values) {
        if (words is List) {
          allWords.addAll(words.cast<String>());
        }
      }
      user.allLearnedWords = allWords.toList();
      user.totalLearnedWords = allWords.length;
      
      // Update streak
      user.currentStreak = await _calculateStreak(user.dailyProgress);
      
      await AuthService.updateUser(user);
    }
  }

  static Future<Map<String, List<String>>> getDailyProgress() async {
    final user = _getCurrentUser();
    if (user == null) return {};
    
    final Map<String, List<String>> progress = {};
    user.dailyProgress.forEach((key, value) {
      if (value is List) {
        progress[key.toString()] = value.cast<String>();
      }
    });
    
    return progress;
  }

  static Future<List<String>> getAllLearnedWords() async {
    final user = _getCurrentUser();
    return user?.allLearnedWords ?? [];
  }

  static Future<int> getTotalLearnedWordsCount() async {
    final user = _getCurrentUser();
    return user?.totalLearnedWords ?? 0;
  }

  static Future<int> getCurrentStreak() async {
    final user = _getCurrentUser();
    return user?.currentStreak ?? 0;
  }

  static Future<int> getWordsLearnedToday() async {
    final progress = await getDailyProgress();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return progress[today]?.length ?? 0;
  }

  // Helper to calculate streak
  static Future<int> _calculateStreak(Map<dynamic, dynamic> dailyProgress) async {
    final today = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 365; i++) { // Check up to 1 year back
      final date = today.subtract(Duration(days: i));
      final dateString = date.toIso8601String().split('T')[0];
      
      if (dailyProgress.containsKey(dateString)) {
        final words = dailyProgress[dateString];
        if (words is List && words.isNotEmpty) {
          streak++;
        } else {
          break;
        }
      } else {
        break;
      }
    }
    
    return streak;
  }
}
