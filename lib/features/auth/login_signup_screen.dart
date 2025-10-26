import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../data/language_data.dart';
import '../../services/auth_service.dart';

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
      Map<String, dynamic> result;
      
      if (_isLogin) {
        // Login
        result = await AuthService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        // Signup
        result = await AuthService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          selectedLanguage: _selectedLanguage!,
        );
      }
      
      if (mounted) {
        if (result['success']) {
          // Success - navigate to home
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
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
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password is required';
                                }
                                // Only validate on signup
                                if (!_isLogin) {
                                  return AuthService.validatePassword(v);
                                }
                                return null;
                              },
                            ),
                            
                            // Password requirements (only for signup)
                            if (!_isLogin) ...[
                              SizedBox(height: MediaQuery.of(context).size.width > 600 ? 8 : 6),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password must contain:',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    _buildPasswordRequirement('At least 8 characters'),
                                    _buildPasswordRequirement('One uppercase letter (A-Z)'),
                                    _buildPasswordRequirement('One lowercase letter (a-z)'),
                                    _buildPasswordRequirement('One number (0-9)'),
                                  ],
                                ),
                              ),
                            ],
                            
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

  Widget _buildPasswordRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


