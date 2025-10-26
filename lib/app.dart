import 'package:flutter/material.dart';
import 'routes.dart';
import 'features/auth/login_signup_screen.dart';
import 'features/home/home_shell.dart';
import 'features/word/word_details_screen.dart';
import 'features/learned/learned_words_screen.dart';
import 'services/auth_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    final isLoggedIn = AuthService.isLoggedIn();
    
    return MaterialApp(
      title: 'LinguaFive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.auth,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.auth:
            return MaterialPageRoute(builder: (_) => const LoginSignupScreen());
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => const HomeShell());
          case AppRoutes.wordDetails:
            return MaterialPageRoute(
              builder: (_) => WordDetailsScreen(
                word: (settings.arguments as Map?)?['word'] as String?,
                translation: (settings.arguments as Map?)?['translation'] as String?,
                pronunciation: (settings.arguments as Map?)?['pronunciation'] as String?,
                examples: (settings.arguments as Map?)?['examples'] as List<String>?,
              ),
            );
          case AppRoutes.learnedWords:
            return MaterialPageRoute(builder: (_) => const LearnedWordsScreen());
          default:
            return MaterialPageRoute(builder: (_) => const LoginSignupScreen());
        }
      },
    );
  }
}


