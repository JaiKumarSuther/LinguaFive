// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapter Generator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      passwordHash: fields[2] as String,
      selectedLanguage: fields[3] as String,
      createdAt: fields[4] as DateTime,
      lastLoginAt: fields[5] as DateTime,
      currentStreak: fields[6] as int,
      totalLearnedWords: fields[7] as int,
      learnedWords: (fields[8] as List?)?.cast<String>(),
      allLearnedWords: (fields[9] as List?)?.cast<String>(),
      dailyProgress: (fields[10] as Map?)?.cast<dynamic, dynamic>(),
      lastQuizResults: (fields[11] as List?)?.cast<String>(),
      dailyReminder: fields[12] as bool,
      reminderTime: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.passwordHash)
      ..writeByte(3)
      ..write(obj.selectedLanguage)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastLoginAt)
      ..writeByte(6)
      ..write(obj.currentStreak)
      ..writeByte(7)
      ..write(obj.totalLearnedWords)
      ..writeByte(8)
      ..write(obj.learnedWords)
      ..writeByte(9)
      ..write(obj.allLearnedWords)
      ..writeByte(10)
      ..write(obj.dailyProgress)
      ..writeByte(11)
      ..write(obj.lastQuizResults)
      ..writeByte(12)
      ..write(obj.dailyReminder)
      ..writeByte(13)
      ..write(obj.reminderTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

