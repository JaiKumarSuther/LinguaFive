import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(UserModelAdapter());
  
  // Open boxes
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('settings');
  
  runApp(const App());
}
