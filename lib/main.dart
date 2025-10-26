import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'models/user_model.dart';

/// Entry point for LinguaFive application.
/// 
/// Initializes:
/// - Flutter framework bindings
/// - Hive local database with type adapters
/// - User and settings data boxes
/// 
/// This addresses Constraint 4: Local data storage using Hive NoSQL database
/// for fast, type-safe, cross-platform data persistence.
void main() async {
  // Ensure Flutter framework is initialized before async operations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for Flutter (sets up correct storage path for each platform)
  await Hive.initFlutter();
  
  // Register type adapters for custom objects (UserModel)
  // This enables Hive to serialize/deserialize UserModel objects
  Hive.registerAdapter(UserModelAdapter());
  
  // Open Hive boxes (similar to database tables)
  // 'users' box: Stores UserModel objects with email as key
  // 'settings' box: Stores app-level settings and current user session
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('settings');
  
  // Launch the app
  runApp(const App());
}
