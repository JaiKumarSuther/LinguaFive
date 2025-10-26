# LinguaFive 🌍

[![Flutter](https://img.shields.io/badge/Flutter-3.9.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.0-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**LinguaFive** - Learn languages with just 5 words a day! A cross-platform mobile application that makes language learning sustainable through microlearning.

## 📱 About

LinguaFive is a language learning app built with Flutter that implements a scientifically-backed microlearning approach. By limiting daily vocabulary to exactly 5 words, the app prevents cognitive overload and promotes long-term retention through:

- **Daily Word Learning**: 5 carefully curated words per day
- **Interactive Practice**: Flash cards, pronunciation, word search, and review modes
- **Gamified Experience**: Quizzes, daily challenges, and streak tracking
- **Multi-language Support**: Spanish, French, German, Japanese, and Chinese
- **Progress Tracking**: Visual dashboards showing your learning journey

## 🎯 Complex Engineering Problem

This project addresses the **real-world problem of language learning overwhelm** where traditional apps present too much content, leading to high dropout rates. LinguaFive solves this through:

1. **Constraint-based Learning**: 5-word daily limit based on cognitive science
2. **Responsive Cross-platform Design**: Uniform experience across all devices
3. **Efficient Local Storage**: Fast, privacy-focused data persistence
4. **Professional Code Standards**: Maintainable, scalable architecture

### Key Constraints Addressed

| Constraint | Implementation |
|------------|---------------|
| ✅ Cross-platform compatibility | Flutter framework with responsive design |
| ✅ Professional development standards | Flutter lints, modular architecture |
| ✅ Code maintainability | Feature-based structure, service layer |
| ✅ Data storage | Hive NoSQL local database |
| ✅ State management | StatefulWidget with service layer |

## ✨ Features

### 🎓 Learning Features
- **Today's Words**: Daily curated 5-word vocabulary
- **Word Details**: Pronunciation, translation, and example sentences
- **Flash Cards**: Interactive memorization practice
- **Pronunciation Practice**: Text-to-Speech in multiple languages
- **Word Search Game**: Pattern recognition through gameplay
- **Review Mode**: Spaced repetition for retention
- **Daily Challenge**: Consistent engagement rewards

### 📊 Progress Tracking
- **Dashboard**: Visual statistics and learning insights
- **Streak Counter**: Track consecutive learning days
- **Learned Words**: View all mastered vocabulary
- **Quiz Verification**: Test your knowledge with MCQs

### ⚙️ Customization
- **5 Languages**: Spanish, French, German, Japanese, Chinese
- **User Authentication**: Secure login with password validation
- **Daily Reminders**: Customizable study notifications
- **Profile Management**: Personalized learning experience

## 🏗️ Architecture

```
lib/
├── main.dart                 # Entry point, Hive initialization
├── app.dart                  # Material App configuration
├── routes.dart               # Route definitions
├── models/                   # Data models
│   ├── user_model.dart       # User data with Hive annotations
│   └── user_model.g.dart     # Generated Hive adapter
├── services/                 # Business logic layer
│   ├── auth_service.dart     # Authentication service
│   └── user_preferences.dart # User data management
├── utils/                    # Utility classes
│   └── responsive_layout.dart # Responsive design utilities
├── data/                     # Static data
│   └── language_data.dart    # 5-language vocabulary database
└── features/                 # Feature modules (UI + logic)
    ├── auth/                 # Authentication screens
    ├── home/                 # Home navigation shell
    ├── dashboard/            # Progress dashboard
    ├── today/                # Daily words screen
    ├── practice/             # Practice mode screens
    ├── quiz/                 # Quiz system
    ├── learned/              # Learned words list
    ├── word/                 # Word details
    └── settings/             # App settings
```

### Design Principles

1. **Feature-based Structure**: Each feature in its own directory with related files
2. **Service Layer Separation**: Business logic isolated from UI
3. **Reusable Components**: Custom widgets for consistency
4. **Responsive Design**: Adaptive layouts for all screen sizes
5. **Type Safety**: Null safety and strong typing throughout

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.0 or higher
- Dart SDK 3.9.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/linguafive.git
   cd linguafive/lingua-five-frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

**Web**
```bash
flutter build web --release
```

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `hive` | ^2.2.3 | Local NoSQL database |
| `hive_flutter` | ^1.1.0 | Hive Flutter integration |
| `crypto` | ^3.0.3 | Password hashing (SHA-256) |
| `flutter_tts` | ^3.8.5 | Text-to-Speech for pronunciation |
| `shared_preferences` | ^2.2.2 | Simple key-value storage |
| `flutter_lints` | ^5.0.0 | Code quality enforcement |

## 🎨 Responsive Design

LinguaFive implements responsive design for optimal experience across devices:

### Breakpoints
- **Mobile**: < 600px width
- **Tablet**: 600px - 900px width
- **Desktop**: > 900px width

### Responsive Features
```dart
// Example: Adaptive padding
padding: EdgeInsets.all(
  ResponsiveLayout.getResponsivePadding(context),
)

// Example: Conditional layouts
ResponsiveLayout.buildResponsive(
  context: context,
  mobile: MobileLayout(),
  tablet: TabletLayout(),
  desktop: DesktopLayout(),
)
```

See `lib/utils/responsive_layout.dart` for full utility class.

## 🔒 Security

- **Password Hashing**: SHA-256 with salt
- **Local Storage**: Hive with encryption support
- **Input Validation**: Email and password validation
- **Secure State**: No sensitive data in memory

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter test integration_test/
```

## 📊 Performance

- **Fast Local Storage**: Hive is 10x faster than SharedPreferences
- **Optimized Builds**: Efficient widget rebuilds with localized setState
- **Lazy Loading**: On-demand data loading
- **60 FPS**: Smooth animations and transitions

## 🐛 Issues & Bugs Encountered During Development

This section demonstrates the debugging and problem-solving journey throughout the development process.

---

### Issue 1: Password Validation Not User-Friendly ❌

**Problem**: Users couldn't sign up because password requirements weren't displayed, leading to repeated failures.

**Error Screenshot**:

![Password Validation Error](assets/error-images/Screenshot%202025-10-24%20225051.png)
*Generic error message without showing requirements*

**Root Cause**: 
- No visual feedback showing password requirements
- Users had to guess what made a valid password
- Error only appeared after submission attempt

**Solution Applied**:
```dart
// Added real-time password validation checklist
Widget _buildPasswordRequirement(String text, bool met) {
  return Row(
    children: [
      Icon(
        met ? Icons.check_circle : Icons.cancel,
        color: met ? Colors.green : Colors.red,
        size: 20,
      ),
      const SizedBox(width: 8),
      Text(text, style: TextStyle(color: met ? Colors.green : Colors.red)),
    ],
  );
}
```

**Requirements Implemented**:
- ✅ Minimum 8 characters
- ✅ At least one uppercase letter
- ✅ At least one lowercase letter  
- ✅ At least one number

---

### Issue 2: User Progress Not Persisting Between Sessions ❌

**Problem**: All learned words and progress were lost when the app was closed and reopened.

**Error Screenshot**:

![Data Persistence Error](assets/error-images/Screenshot%202025-10-24%20225119.png)
*User progress reset to zero after app restart*

**Root Cause**:
- Data was stored in memory state only
- No calls to persist data to Hive database
- User object updates weren't being saved

**Solution Applied**:
```dart
// Added AuthService.updateUser() after every progress change
final user = AuthService.getCurrentUser();
if (user != null) {
  user.learnedWords.add(word);
  await AuthService.updateUser(user); // ← Critical line added
}
```

**Files Modified**: `user_preferences.dart`, all progress tracking functions

---

### Issue 3: Chinese Language TTS Not Working ❌

**Problem**: Text-to-Speech worked for Spanish, French, German, Japanese but failed silently for Chinese words.

**Error Screenshots**:

![Chinese TTS Error 1](assets/error-images/Screenshot%202025-10-25%20002707.png)
*TTS error when attempting to pronounce Chinese words*

![Chinese TTS Error 2](assets/error-images/Screenshot%202025-10-25%20002721.png)
*Additional TTS failure screenshot*

**Root Cause**: Missing language code mapping for Chinese in the `_getLanguageCode()` method

**Solution Applied**:
```dart
String _getLanguageCode() {
  switch (widget.language.toLowerCase()) {
    case 'spanish': return 'es-ES';
    case 'french': return 'fr-FR';
    case 'german': return 'de-DE';
    case 'japanese': return 'ja-JP';
    case 'chinese': return 'zh-CN'; // ← Added this line
    default: return 'en-US';
  }
}
```

**Impact**: Chinese learners can now use pronunciation practice feature ✅

---

### Issue 4: RenderFlex Overflow Errors (Multiple Screens) ❌

**Problem**: Text and content overflowing on smaller screen sizes causing rendering errors and broken UI.

**Error Screenshots**:

![Dashboard Overflow](assets/error-images/Screenshot%202025-10-25%20004103.png)
*Dashboard screen with RenderFlex overflow error*

![Today Screen Overflow](assets/error-images/Screenshot%202025-10-25%20004118.png)
*Today's words screen showing text overflow*

![Quiz Screen Overflow](assets/error-images/Screenshot%202025-10-25%20004329.png)
*Quiz screen with multiple overflow errors*

**Root Cause**:
- Fixed-size containers with unbounded content
- Long words/translations without proper text wrapping
- Nested `ListView` without proper height constraints
- No responsive design considerations

**Solution Applied**:
```dart
// Before (causes overflow) ❌
Column(
  children: [
    Text(word.pronunciation), // Can overflow
    ListView(children: items), // Unbounded height
  ],
)

// After (fixed) ✅
SingleChildScrollView(
  child: Column(
    children: [
      Flexible(
        child: Text(
          word.pronunciation,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: items,
      ),
    ],
  ),
)
```

**Files Modified**: 
- `dashboard_screen.dart`
- `today_screen.dart`
- `quiz_screen.dart`
- `word_details_screen.dart`
- `pronunciation_screen.dart`
- `flash_cards_screen.dart`
- `review_words_screen.dart`
- `daily_challenge_screen.dart`

**Total**: 8 screen files fixed ✅

---

### Issue 5: Compilation Errors After Overflow Fixes ❌

**Problem**: After applying overflow fixes, the app wouldn't compile due to syntax errors.

**Error Screenshots**:

![Compilation Error 1](assets/error-images/Screenshot%202025-10-25%20004455.png)
*Missing closing brackets causing compilation failure*

![Compilation Error 2](assets/error-images/Screenshot%202025-10-25%20004517.png)
*Additional syntax errors in multiple files*

![Compilation Error 3](assets/error-images/Screenshot%202025-10-25%20010256.png)
*More unmatched parentheses errors*

**Error Messages**:
```
Error: Expected ']' but found '}'
Error: Expected ')' but found EOF  
Error: Unmatched closing bracket
```

**Root Cause**: Accidentally removed/mismatched closing brackets while refactoring deeply nested widget trees

**Solution**: 
- Carefully traced the widget tree structure
- Used VS Code's bracket matching feature
- Added missing brackets systematically
- Verified proper nesting with indentation

**Lesson Learned**: Use IDE bracket highlighting and count opening/closing brackets when refactoring ✅

---

### Issue 6: Word Search Game Not Interactive ❌

**Problem**: Word search grid displayed correctly but users couldn't select words by dragging their finger.

**Error Screenshot**:

![Word Search Not Working](assets/error-images/Screenshot%202025-10-26%20194547.png)
*Word search game visible but no drag interaction working*

**Root Cause**:
- Multiple `GestureDetector` widgets (one per cell) causing gesture conflicts
- Incorrect conversion of touch position to grid cell coordinates
- Pan gesture updates not properly detecting cell positions

**Solution Applied**:
```dart
// Before (multiple detectors causing conflicts) ❌
Grid.map((cell) => GestureDetector(
  onTapDown: (_) => selectCell(),
  child: Cell(),
))

// After (single gesture detector) ✅
GestureDetector(
  onPanStart: (details) {
    final cell = _getCellFromPosition(details.localPosition);
    if (cell != null) _onCellTap(cell[0], cell[1]);
  },
  onPanUpdate: (details) {
    final cell = _getCellFromPosition(details.localPosition);
    if (cell != null) _onCellDragUpdate(cell[0], cell[1]);
  },
  onPanEnd: (_) => _onCellDragEnd(),
  child: Grid(),
)

// Helper method for accurate position calculation
List<int>? _getCellFromPosition(Offset position) {
  const cellSize = 30.0; // 28px cell + 2px margin
  final col = (position.dx / cellSize).floor();
  final row = (position.dy / cellSize).floor();
  
  if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
    return [row, col];
  }
  return null;
}
```

**Result**: Smooth drag-to-select functionality with visual feedback (blue → green) ✅

---

### Issue 7: Additional UI/State Issues ❌

**Error Screenshot**:

![Additional Error](assets/error-images/Screenshot%202025-10-26%20200110.png)
*Additional error encountered during development*

**Problem**: Various state management and UI rendering issues during feature implementation.

**Solution**: Implemented proper `mounted` checks before `setState` calls and ensured async operations completed correctly.

---

## 📊 Error Resolution Summary

| Issue Category | Screenshots | Files Affected | Time to Fix | Complexity |
|---------------|-------------|----------------|-------------|------------|
| Password Validation UX | 1 | 1 file | 30 mins | Low |
| Data Persistence | 1 | 2 files | 1 hour | Medium |
| TTS Language Support | 2 | 1 file | 20 mins | Low |
| UI Overflow Errors | 3 | 8 files | 2.5 hours | Medium-High |
| Compilation/Syntax | 3 | 3 files | 45 mins | Low-Medium |
| Gesture Detection | 1 | 1 file | 1.5 hours | High |
| State Management | 1 | Multiple | 30 mins | Medium |
| **TOTAL** | **12 screenshots** | **16+ files** | **~7 hours** | **Mixed** |

---

## 🎓 Lessons Learned

1. **Test on Multiple Screen Sizes** - Prevents overflow errors; use responsive design from the start
2. **Use Single Gesture Detectors for Grids** - Avoids gesture conflicts and improves performance
3. **Track Brackets Carefully** - Use IDE bracket matching when refactoring nested widgets
4. **Test All Languages/Locales** - Each language may need specific configuration (TTS codes)
5. **Show Validation Rules Upfront** - Better UX than showing errors after submission
6. **Persist Data Immediately** - Don't rely on memory state; save to database on every change
7. **Add `mounted` Checks** - Always check widget is still mounted before `setState` after async
8. **Use Flutter DevTools** - Widget inspector helps debug layout issues quickly
9. **Test Edge Cases** - Long text, empty states, network failures, etc.
10. **Document Errors** - Screenshots help remember solutions for future similar issues

---

## 🛠️ Debugging Tools Used

- **Flutter DevTools**: Widget inspector for layout issues
- **VS Code Bracket Matching**: For syntax error resolution
- **Android Studio Logcat**: For runtime error messages
- **Flutter Analyze**: For code quality issues
- **Hot Reload**: For rapid iteration during fixes

---

## 📖 Code Structure

For detailed code implementation, see:
- `lib/services/` - Authentication and user preferences services
- `lib/models/` - Data models with Hive annotations
- `lib/features/` - Feature-based UI modules
- `lib/utils/` - Responsive layout utilities

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Follow code standards (run `flutter analyze`)
4. Commit changes (`git commit -m 'Add AmazingFeature'`)
5. Push to branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Authors

- **Your Name** - *Initial work* - [YourGitHub](https://github.com/yourusername)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design guidelines
- Cognitive psychology research on spaced repetition
- Language learning community for feedback

## 📧 Contact

For questions or feedback, please open an issue or contact:
- Email: your.email@example.com
- GitHub: [@yourusername](https://github.com/yourusername)

---

**Built with ❤️ using Flutter**
