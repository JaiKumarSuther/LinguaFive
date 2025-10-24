import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pakistaniNames = [
      'Ahmed Khan', 'Fatima Ali', 'Muhammad Hassan', 'Aisha Malik', 'Ali Raza',
      'Zainab Sheikh', 'Omar Farooq', 'Hina Ahmed', 'Usman Khan', 'Sara Khan',
      'Bilal Ahmad', 'Maryam Ali', 'Tariq Hussain', 'Nida Sheikh', 'Hamza Khan',
      'Ayesha Malik', 'Saad Ali', 'Khadija Khan', 'Fahad Ahmed', 'Zara Sheikh'
    ];
    
    final entries = List.generate(20, (i) => {
      'name': pakistaniNames[i], 
      'score': (200 - i * 3)
    });
    
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Leaderboard',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Top language learners',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Leaderboard List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final e = entries[i];
                    final isTopThree = i < 3;
                    
                    return Card(
                      elevation: isTopThree ? 4 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isTopThree 
                                ? _getRankColor(i).withOpacity(0.1)
                                : Theme.of(context).colorScheme.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: isTopThree
                                ? Icon(
                                    _getRankIcon(i),
                                    color: _getRankColor(i),
                                    size: 20,
                                  )
                                : Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                          ),
                        ),
                        title: Text(
                          e['name'].toString(),
                          style: TextStyle(
                            fontWeight: isTopThree ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${e['score']} xp',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0: return Colors.amber; // Gold
      case 1: return Colors.grey;  // Silver
      case 2: return Colors.orange; // Bronze
      default: return Colors.grey;
    }
  }

  IconData _getRankIcon(int index) {
    switch (index) {
      case 0: return Icons.emoji_events; // Gold trophy
      case 1: return Icons.emoji_events; // Silver trophy
      case 2: return Icons.emoji_events; // Bronze trophy
      default: return Icons.person;
    }
  }
}


