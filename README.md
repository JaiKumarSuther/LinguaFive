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

## 🐛 Known Issues & Resolutions

| Issue | Status | Solution |
|-------|--------|----------|
| Overflow errors on small screens | ✅ Fixed | SingleChildScrollView + Flexible widgets |
| Word Search drag not working | ✅ Fixed | Single GestureDetector with position calculation |
| Chinese TTS not working | ✅ Fixed | Added zh-CN language code |
| Password validation unclear | ✅ Fixed | Visual requirement checklist |

See `docs/PROJECT_DOCUMENTATION.md` for detailed issue descriptions.

## 📖 Documentation

- **[Project Documentation](docs/PROJECT_DOCUMENTATION.md)**: Complete technical documentation
- **[Code Standards](docs/CODE_STANDARDS.md)**: Development guidelines
- **[API Reference](docs/API_REFERENCE.md)**: Service layer documentation

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
