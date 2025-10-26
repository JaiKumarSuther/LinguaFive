import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String passwordHash;

  @HiveField(3)
  late String selectedLanguage;

  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  late DateTime lastLoginAt;

  @HiveField(6)
  late int currentStreak;

  @HiveField(7)
  late int totalLearnedWords;

  @HiveField(8)
  late List<String> learnedWords;

  @HiveField(9)
  late List<String> allLearnedWords;

  @HiveField(10)
  late Map<dynamic, dynamic> dailyProgress; // date -> list of words

  @HiveField(11)
  late List<String> lastQuizResults;

  @HiveField(12)
  late bool dailyReminder;

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

