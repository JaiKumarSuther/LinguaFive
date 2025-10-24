import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../data/language_data.dart';
import '../../services/user_preferences.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _obscure = true;
  String? _selectedLanguage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _selectedLanguage = null; // Reset language selection when switching modes
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    // For signup, require language selection
    if (!_isLogin && _selectedLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a language to learn')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: hook to backend auth
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Save user preferences
      await UserPreferences.setUserEmail(_emailController.text);
      await UserPreferences.setLoggedIn(true);
      
      if (!_isLogin && _selectedLanguage != null) {
        await UserPreferences.setSelectedLanguage(_selectedLanguage!);
      }
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width > 600 ? 420 : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width > 600 ? 24.0 : 16.0,
                  ),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width > 600 ? 24.0 : 20.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              // App Logo/Title
                              Container(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width > 600 ? 16 : 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/favicon.png',
                                  width: MediaQuery.of(context).size.width > 600 ? 48 : 40,
                                  height: MediaQuery.of(context).size.width > 600 ? 48 : 40,
                                ),
                              ),
                            SizedBox(height: MediaQuery.of(context).size.width > 600 ? 16 : 12),
                            Text(
                              'LinguaFive',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: MediaQuery.of(context).size.width > 600 ? null : 24,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width > 600 ? 8 : 6),
                            Text(
                              _isLogin ? 'Welcome back!' : 'Start your language journey',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: MediaQuery.of(context).size.width > 600 ? null : 16,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width > 600 ? 32 : 24),
                            
                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                              validator: (v) => (v == null || v.isEmpty || !v.contains('@'))
                                  ? 'Enter a valid email'
                                  : null,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width > 600 ? 16 : 12),
                            
                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                              validator: (v) => (v == null || v.length < 6)
                                  ? 'Min 6 characters'
                                  : null,
                            ),
                            
                            // Language Selection (only for signup)
                            if (!_isLogin) ...[
                              SizedBox(height: MediaQuery.of(context).size.width > 600 ? 16 : 12),
                              DropdownButtonFormField<String>(
                                value: _selectedLanguage,
                                decoration: InputDecoration(
                                  labelText: 'Language to learn',
                                  prefixIcon: const Icon(Icons.public),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                ),
                                items: LanguageRepository.availableLanguages.map((langCode) {
                                  final language = LanguageRepository.getLanguage(langCode);
                                  return DropdownMenuItem(
                                    value: langCode,
                                    child: Row(
                                      children: [
                                        Text(language?.flag ?? '🌍', style: const TextStyle(fontSize: 20)),
                                        const SizedBox(width: 12),
                                        Text(language?.name ?? langCode),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) => setState(() => _selectedLanguage = value),
                                validator: (v) => v == null ? 'Please select a language' : null,
                              ),
                            ],
                            
                            SizedBox(height: MediaQuery.of(context).size.width > 600 ? 24 : 20),
                            
                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.width > 600 ? 48 : 44,
                              child: FilledButton(
                                onPressed: _isLoading ? null : _submit,
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        height: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                                        width: MediaQuery.of(context).size.width > 600 ? 20 : 18,
                                        child: const CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : Text(
                                        _isLogin ? 'Login' : 'Create account',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            
                            SizedBox(height: MediaQuery.of(context).size.width > 600 ? 16 : 12),
                            
                            // Toggle Mode Button
                            TextButton(
                              onPressed: _isLoading ? null : _toggleMode,
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: [
                                    TextSpan(
                                      text: _isLogin ? "Don't have an account? " : "Already have an account? ",
                                    ),
                                    TextSpan(
                                      text: _isLogin ? "Sign up" : "Login",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


