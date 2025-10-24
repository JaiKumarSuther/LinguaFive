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
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // App Logo/Title
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.language,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'LinguaFive',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isLogin ? 'Welcome back!' : 'Start your language journey',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 32),
                            
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
                            const SizedBox(height: 16),
                            
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
                              const SizedBox(height: 16),
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
                            
                            const SizedBox(height: 24),
                            
                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton(
                                onPressed: _isLoading ? null : _submit,
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : Text(
                                        _isLogin ? 'Login' : 'Create account',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
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


