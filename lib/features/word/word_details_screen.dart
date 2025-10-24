import 'package:flutter/material.dart';
import '../../services/user_preferences.dart';

class WordDetailsScreen extends StatefulWidget {
  final String? word;
  final String? translation;
  final String? pronunciation;
  final List<String>? examples;

  const WordDetailsScreen({super.key, this.word, this.translation, this.pronunciation, this.examples});

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen> {
  bool _isLearned = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLearnedStatus();
  }

  Future<void> _checkLearnedStatus() async {
    if (widget.word != null) {
      final isLearned = await UserPreferences.isWordLearned(widget.word!);
      setState(() {
        _isLearned = isLearned;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleLearnedStatus() async {
    if (widget.word == null) return;
    
    setState(() => _isLoading = true);
    
    if (_isLearned) {
      await UserPreferences.removeLearnedWord(widget.word!);
    } else {
      await UserPreferences.addLearnedWord(widget.word!);
    }
    
    setState(() {
      _isLearned = !_isLearned;
      _isLoading = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLearned 
              ? 'Word marked as learned! 🎉' 
              : 'Word removed from learned list'),
          backgroundColor: _isLearned ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  String _getExampleTranslation(String example) {
    // Simple translation mapping for common Spanish examples
    final translations = {
      'Hola, ¿cómo estás?': 'Hello, how are you?',
      'Hola a todos.': 'Hello everyone.',
      'Hola, buenos días.': 'Hello, good morning.',
      'Muchas gracias': 'Thank you very much',
      'Gracias por venir': 'Thank you for coming',
      'Gracias de antemano': 'Thank you in advance',
      'Adiós, nos vemos': 'Goodbye, see you later',
      'Adiós, hasta luego': 'Goodbye, see you later',
      'Adiós, que tengas buen día': 'Goodbye, have a good day',
      'Por favor, ven aquí': 'Please, come here',
      'Por favor, ayúdame': 'Please, help me',
      'Por favor, siéntate': 'Please, sit down',
      'Sí, claro': 'Yes, of course',
      'Sí, por supuesto': 'Yes, of course',
      'Sí, me gusta': 'Yes, I like it',
      'No, gracias': 'No, thank you',
      'No, no quiero': 'No, I don\'t want to',
      'No, no puedo': 'No, I can\'t',
      'Necesito agua': 'I need water',
      'El agua está fría': 'The water is cold',
      'Bebe agua': 'Drink water',
      'La comida está rica': 'The food is delicious',
      'Necesito comida': 'I need food',
      '¿Dónde está la comida?': 'Where is the food?',
      'Mi casa es grande': 'My house is big',
      'Voy a casa': 'I\'m going home',
      'La casa está limpia': 'The house is clean',
      'Mi familia es grande': 'My family is big',
      'Amo a mi familia': 'I love my family',
      'La familia está reunida': 'The family is gathered',
    };
    
    return translations[example] ?? 'Translation not available';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Text(
                        'Word Details',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Word
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    widget.word ?? '-',
                                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.record_voice_over,
                                        size: 20,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.pronunciation ?? '-',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Translation
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.translate,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Translation',
                                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.translation ?? '-',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Examples
                          Text(
                            'Usage Examples',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.separated(
                              itemCount: (widget.examples ?? <String>[]).length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final example = widget.examples![index];
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onPrimary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              example,
                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 32),
                                        child: Text(
                                          _getExampleTranslation(example),
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Mark as Learned Button
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _isLoading ? null : _toggleLearnedStatus,
                              icon: _isLoading 
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Icon(_isLearned ? Icons.check_circle : Icons.school),
                              label: Text(_isLearned ? 'Marked as Learned' : 'Mark as Learned'),
                              style: FilledButton.styleFrom(
                                backgroundColor: _isLearned 
                                    ? Colors.green 
                                    : Theme.of(context).colorScheme.primary,
                                foregroundColor: _isLearned 
                                    ? Colors.white 
                                    : Theme.of(context).colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
