import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _selectedLanguageKey = 'selected_language';
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _dailyReminderKey = 'daily_reminder';
  static const String _reminderTimeKey = 'reminder_time';
  static const String _learnedWordsKey = 'learned_words';

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
  }
}
