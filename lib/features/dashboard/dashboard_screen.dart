import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int streak = 7;
    final int totalWords = 123;
    final int learnedThisWeek = 25;

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatCard(title: 'Streak', value: '$streak🔥'),
                const SizedBox(width: 12),
                _StatCard(title: 'Total', value: '$totalWords📚'),
                const SizedBox(width: 12),
                _StatCard(title: 'This Week', value: '$learnedThisWeek✅'),
              ],
            ),
            const SizedBox(height: 24),
            Text('Recent Activity', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) => ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text('Learned word #${i + 1}'),
                  subtitle: const Text('2 xp'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}


