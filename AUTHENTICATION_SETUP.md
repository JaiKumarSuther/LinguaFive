# Authentication System with Hive

## Overview
The app now uses **Hive** (a fast, local NoSQL database) for user authentication and data storage. All user data, including login credentials, learning progress, and preferences, are stored securely on the device.

## Features

### 🔐 Secure Authentication
- **Password Hashing**: Passwords are hashed using SHA-256 before storage
- **Email Validation**: Proper email format validation
- **Password Requirements**:
  - Minimum 8 characters
  - At least one uppercase letter (A-Z)
  - At least one lowercase letter (a-z)
  - At least one number (0-9)

### 📊 User Data Storage
All user data is stored locally using Hive:
- User credentials (email and hashed password)
- Selected learning language
- Learned words (marked by user)
- All learned words (quiz-verified)
- Daily progress tracking
- Current streak
- Quiz results
- Reminder preferences

### 🎯 Progress Tracking
- **Learned Words**: Words marked as learned by the user
- **Quiz-Verified Words**: Words that passed the quiz validation
- **Daily Progress**: Track words learned each day
- **Streak Counter**: Days in a row with learning activity
- **Statistics**: Total words learned, words learned today, etc.

## Setup Instructions

### 1. Install Dependencies
Run the following command to install the required packages:
```bash
cd lingua-five-frontend
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

The app will automatically:
- Initialize Hive database
- Register the UserModel adapter
- Open required boxes (users and settings)

## File Structure

```
lib/
├── models/
│   ├── user_model.dart          # User data model with Hive annotations
│   └── user_model.g.dart        # Generated Hive adapter
├── services/
│   ├── auth_service.dart        # Authentication logic
│   └── user_preferences.dart    # User preferences and data access
├── features/
│   └── auth/
│       └── login_signup_screen.dart  # Login/Signup UI
└── main.dart                    # Hive initialization
```

## Usage

### Sign Up
1. Open the app (it will show the auth screen if not logged in)
2. Click "Sign up" at the bottom
3. Enter email and password (meeting requirements)
4. Select your learning language
5. Click "Create account"

### Login
1. Enter your registered email
2. Enter your password
3. Click "Login"

### Logout
1. Go to Settings tab
2. Click "Logout" under Account section

## API Reference

### AuthService

#### Sign Up
```dart
final result = await AuthService.signUp(
  email: 'user@example.com',
  password: 'SecurePass123',
  selectedLanguage: 'spanish',
);
```

#### Login
```dart
final result = await AuthService.login(
  email: 'user@example.com',
  password: 'SecurePass123',
);
```

#### Get Current User
```dart
final user = AuthService.getCurrentUser();
if (user != null) {
  print('Logged in as: ${user.email}');
}
```

#### Check Login Status
```dart
final isLoggedIn = AuthService.isLoggedIn();
```

#### Logout
```dart
await AuthService.logout();
```

### UserPreferences

#### Save/Get Language
```dart
await UserPreferences.setSelectedLanguage('spanish');
final language = await UserPreferences.getSelectedLanguage();
```

#### Learned Words
```dart
// Add learned word
await UserPreferences.addLearnedWord('hola');

// Get all learned words
final words = await UserPreferences.getLearnedWords();

// Check if word is learned
final isLearned = await UserPreferences.isWordLearned('hola');

// Remove learned word
await UserPreferences.removeLearnedWord('hola');
```

#### Progress Tracking
```dart
// Save daily progress (quiz-verified words)
await UserPreferences.saveDailyProgress(['hola', 'gracias', 'buenos']);

// Get current streak
final streak = await UserPreferences.getCurrentStreak();

// Get words learned today
final todayCount = await UserPreferences.getWordsLearnedToday();

// Get total learned words count
final totalCount = await UserPreferences.getTotalLearnedWordsCount();
```

## Data Persistence

### Storage Location
Hive stores data locally on the device:
- **Windows**: `%USERPROFILE%\AppData\Roaming\<app_name>`
- **Android**: Internal app storage
- **iOS**: Documents directory
- **Web**: IndexedDB

### Boxes
The app uses two Hive boxes:
1. **users** (TypedBox<UserModel>): Stores all user accounts
2. **settings** (Box): Stores app-wide settings and current user

## Security Considerations

### Password Security
- Passwords are **never stored in plain text**
- SHA-256 hashing is used (consider using bcrypt for production)
- Passwords are validated on signup

### Data Encryption
For production apps, consider:
- Enabling Hive encryption: `await Hive.openBox('users', encryptionKey: key)`
- Using flutter_secure_storage for encryption keys

### Best Practices
- Always validate user input
- Use proper error handling
- Implement rate limiting for login attempts (future enhancement)
- Consider adding biometric authentication

## Troubleshooting

### Error: "User already exists"
- The email is already registered
- Use a different email or login with existing account

### Error: "Invalid password"
- Check password requirements (8+ chars, uppercase, lowercase, number)
- Ensure you're entering the correct password for login

### Data Reset
To reset all data (for testing):
```dart
await Hive.deleteBoxFromDisk('users');
await Hive.deleteBoxFromDisk('settings');
```

## Future Enhancements

- [ ] Backend API integration
- [ ] Cloud sync
- [ ] Biometric authentication
- [ ] Password reset functionality
- [ ] Email verification
- [ ] Two-factor authentication
- [ ] Social login (Google, Facebook)

## Dependencies

```yaml
dependencies:
  hive: ^2.2.3              # Local database
  hive_flutter: ^1.1.0      # Flutter integration
  crypto: ^3.0.3            # Password hashing
```

## License
This authentication system is part of the LinguaFive app.

