import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// User data model for local storage using Hive NoSQL database.
/// 
/// **Constraint 4: Data Storage Approach**
/// This model uses local storage via Hive instead of cloud storage because:
/// - Faster data access (no network latency)
/// - Privacy-focused (data never leaves device)
/// - Offline-first (works without internet)
/// - No backend infrastructure costs
/// - Type-safe with compile-time checking
/// 
/// **Data Structure:**
/// - Authentication: id, email, passwordHash (SHA-256)
/// - Progress Tracking: streak, learned words, daily progress
/// - Preferences: language selection, reminder settings
/// - Quiz Results: verification of learned vocabulary
/// 
/// **Hive Annotations:**
/// Each field must have a unique @HiveField(index) for serialization.
/// The type adapter is generated via: `flutter packages pub run build_runner build`
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  /// Unique user identifier (UUID format)
  @HiveField(0)
  late String id;

  /// User's email address (also used as Hive box key for lookups)
  @HiveField(1)
  late String email;

  /// SHA-256 hashed password (never store plain text for security)
  @HiveField(2)
  late String passwordHash;

  /// Currently selected learning language code
  /// Supported: 'spanish', 'french', 'german', 'japanese', 'chinese'
  @HiveField(3)
  late String selectedLanguage;

  /// Account creation timestamp
  @HiveField(4)
  late DateTime createdAt;

  /// Last successful login timestamp (for session management)
  @HiveField(5)
  late DateTime lastLoginAt;

  /// Number of consecutive days with learning activity
  /// Reset to 0 if user misses a day
  @HiveField(6)
  late int currentStreak;

  /// Total count of quiz-verified learned words across all time
  @HiveField(7)
  late int totalLearnedWords;

  /// Words user has marked as learned (may not be quiz-verified yet)
  @HiveField(8)
  late List<String> learnedWords;

  /// All quiz-verified learned words (authoritative learned vocabulary)
  @HiveField(9)
  late List<String> allLearnedWords;

  /// Map of date strings (YYYY-MM-DD) to learned words for that day
  /// Used for streak calculation and progress tracking
  /// Example: {'2025-10-26': ['hello', 'goodbye'], '2025-10-25': ['please']}
  @HiveField(10)
  late Map<dynamic, dynamic> dailyProgress;

  /// Words correctly answered in the most recent quiz session
  @HiveField(11)
  late List<String> lastQuizResults;

  /// Whether daily learning reminders are enabled
  @HiveField(12)
  late bool dailyReminder;

  /// Time for daily reminder in 'HH:MM' format (24-hour)
  /// Example: '09:00' for 9:00 AM
  @HiveField(13)
  late String reminderTime;

  UserModel({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.selectedLanguage,
    required this.createdAt,
    required this.lastLoginAt,
    this.currentStreak = 0,
    this.totalLearnedWords = 0,
    List<String>? learnedWords,
    List<String>? allLearnedWords,
    Map<dynamic, dynamic>? dailyProgress,
    List<String>? lastQuizResults,
    this.dailyReminder = true,
    this.reminderTime = '9:0',
  })  : learnedWords = learnedWords ?? [],
        allLearnedWords = allLearnedWords ?? [],
        dailyProgress = dailyProgress ?? {},
        lastQuizResults = lastQuizResults ?? [];
}

