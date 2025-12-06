import 'package:flutter/material.dart';
import 'principle_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final principles = [
      {
        'letter': 'S',
        'name': 'Single Responsibility',
        'fullName': 'Single Responsibility Principle',
        'color': Colors.blue,
        'path': 'single_responsibility',
      },
      {
        'letter': 'O',
        'name': 'Open/Closed',
        'fullName': 'Open/Closed Principle',
        'color': Colors.green,
        'path': 'open_closed',
      },
      {
        'letter': 'L',
        'name': 'Liskov Substitution',
        'fullName': 'Liskov Substitution Principle',
        'color': Colors.orange,
        'path': 'liskov_substitution',
      },
      {
        'letter': 'I',
        'name': 'Interface Segregation',
        'fullName': 'Interface Segregation Principle',
        'color': Colors.purple,
        'path': 'interface_segregation',
      },
      {
        'letter': 'D',
        'name': 'Dependency Inversion',
        'fullName': 'Dependency Inversion Principle',
        'color': Colors.red,
        'path': 'dependency_inversion',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SOLID Principles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'SOLID Principles',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Five principles of object-oriented design',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: principles.length,
                  itemBuilder: (context, index) {
                    final principle = principles[index];
                    return _PrincipleCard(
                      letter: principle['letter'] as String,
                      name: principle['name'] as String,
                      fullName: principle['fullName'] as String,
                      color: principle['color'] as Color,
                      path: principle['path'] as String,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrincipleDetailScreen(
                              principlePath: principle['path'] as String,
                              principleName: principle['fullName'] as String,
                              principleLetter: principle['letter'] as String,
                              principleColor: principle['color'] as Color,
                            ),
                          ),
                        );
                      },
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
}

class _PrincipleCard extends StatelessWidget {
  final String letter;
  final String name;
  final String fullName;
  final Color color;
  final String path;
  final VoidCallback onTap;

  const _PrincipleCard({
    required this.letter,
    required this.name,
    required this.fullName,
    required this.color,
    required this.path,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fullName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
