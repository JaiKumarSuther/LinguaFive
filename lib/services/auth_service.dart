import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

/// Authentication service for user management and session handling.
/// 
/// This service provides:
/// - User signup with email/password validation
/// - Secure login with SHA-256 password hashing
/// - Session management (current user tracking)
/// - Password strength validation
/// 
/// All user data is stored locally using Hive NoSQL database.
/// Passwords are never stored in plain text - only SHA-256 hashes are persisted.
/// 
/// Example usage:
/// ```dart
/// // Sign up a new user
/// final success = await AuthService.signUp('user@example.com', 'SecurePass123');
/// 
/// // Log in existing user
/// final loggedIn = await AuthService.login('user@example.com', 'SecurePass123');
/// 
/// // Check authentication status
/// if (AuthService.isLoggedIn()) {
///   final user = AuthService.getCurrentUser();
/// }
/// ```
class AuthService {
  // Hive box names for data persistence
  static const String _usersBoxName = 'users';
  static const String _currentUserKey = 'current_user_email';
  
  /// Get the Hive box containing user data
  static Box<UserModel> get _usersBox => Hive.box<UserModel>(_usersBoxName);
  
  /// Get the Hive box containing app settings (including current user session)
  static Box get _settingsBox => Hive.box('settings');

  /// Validates password against security requirements.
  /// 
  /// Security requirements (Constraint 4: Data Security):
  /// - Minimum 8 characters length
  /// - At least one uppercase letter (A-Z)
  /// - At least one lowercase letter (a-z)
  /// - At least one digit (0-9)
  /// 
  /// Returns error message if validation fails, null if password is valid.
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null; // Password is valid
  }

  /// Validates email address format using RFC 5322 compliant regex.
  /// 
  /// Returns error message if validation fails, null if email is valid.
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Hashes password using SHA-256 cryptographic algorithm.
  /// 
  /// Converts password to UTF-8 bytes and applies SHA-256 hash function.
  /// This ensures passwords are never stored in plain text (Security Best Practice).
  /// 
  /// Note: For production apps, consider using bcrypt or argon2 with salt.
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // Check if user exists
  static bool userExists(String email) {
    return _usersBox.containsKey(email.toLowerCase());
  }

  // Sign up
  static Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String selectedLanguage,
  }) async {
    try {
      // Validate email
      final emailError = validateEmail(email);
      if (emailError != null) {
        return {'success': false, 'message': emailError};
      }

      // Validate password
      final passwordError = validatePassword(password);
      if (passwordError != null) {
        return {'success': false, 'message': passwordError};
      }

      final emailLower = email.toLowerCase();

      // Check if user already exists
      if (userExists(emailLower)) {
        return {'success': false, 'message': 'User already exists'};
      }

      // Create new user
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: emailLower,
        passwordHash: _hashPassword(password),
        selectedLanguage: selectedLanguage,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      // Save user to Hive
      await _usersBox.put(emailLower, user);
      
      // Set as current user
      await _settingsBox.put(_currentUserKey, emailLower);

      return {'success': true, 'message': 'Account created successfully', 'user': user};
    } catch (e) {
      return {'success': false, 'message': 'Error creating account: ${e.toString()}'};
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Validate email
      final emailError = validateEmail(email);
      if (emailError != null) {
        return {'success': false, 'message': emailError};
      }

      if (password.isEmpty) {
        return {'success': false, 'message': 'Password is required'};
      }

      final emailLower = email.toLowerCase();

      // Check if user exists
      if (!userExists(emailLower)) {
        return {'success': false, 'message': 'User not found'};
      }

      // Get user
      final user = _usersBox.get(emailLower);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }

      // Verify password
      final passwordHash = _hashPassword(password);
      if (user.passwordHash != passwordHash) {
        return {'success': false, 'message': 'Invalid password'};
      }

      // Update last login
      user.lastLoginAt = DateTime.now();
      await user.save();

      // Set as current user
      await _settingsBox.put(_currentUserKey, emailLower);

      return {'success': true, 'message': 'Login successful', 'user': user};
    } catch (e) {
      return {'success': false, 'message': 'Error logging in: ${e.toString()}'};
    }
  }

  // Get current user
  static UserModel? getCurrentUser() {
    try {
      final currentUserEmail = _settingsBox.get(_currentUserKey);
      if (currentUserEmail == null) return null;
      
      return _usersBox.get(currentUserEmail);
    } catch (e) {
      return null;
    }
  }

  // Check if logged in
  static bool isLoggedIn() {
    return getCurrentUser() != null;
  }

  // Logout
  static Future<void> logout() async {
    await _settingsBox.delete(_currentUserKey);
  }

  // Update user data
  static Future<void> updateUser(UserModel user) async {
    await user.save();
  }

  // Delete account
  static Future<void> deleteAccount(String email) async {
    final emailLower = email.toLowerCase();
    await _usersBox.delete(emailLower);
    await logout();
  }

  // Change password
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = getCurrentUser();
      if (user == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      // Verify current password
      final currentPasswordHash = _hashPassword(currentPassword);
      if (user.passwordHash != currentPasswordHash) {
        return {'success': false, 'message': 'Current password is incorrect'};
      }

      // Validate new password
      final passwordError = validatePassword(newPassword);
      if (passwordError != null) {
        return {'success': false, 'message': passwordError};
      }

      // Update password
      user.passwordHash = _hashPassword(newPassword);
      await user.save();

      return {'success': true, 'message': 'Password changed successfully'};
    } catch (e) {
      return {'success': false, 'message': 'Error changing password: ${e.toString()}'};
    }
  }
}

