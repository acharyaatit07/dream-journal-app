// lib/features/dreams/screens/dreams_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../models/dream.dart';
import '../services/dreams_provider.dart';

class DreamsHomeScreen extends ConsumerWidget {
  const DreamsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dreamsAsync = ref.watch(dreamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnalyticsScreen(),
                ),
              );
            },
            tooltip: 'Dream Analytics',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(dreamsProvider.notifier).loadDreams();
            },
          ),
        ],
      ),
      body: dreamsAsync.when(
        data: (dreams) {
          if (dreams.isEmpty) {
            return _buildEmptyState(context, ref);
          }
          return _buildDreamsList(dreams);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading dreams',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(dreamsProvider.notifier).loadDreams();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDreamDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bedtime_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No dreams yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Start recording your dreams to unlock insights',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddDreamDialog(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Dream'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _addSampleDreams(ref),
            child: const Text('Add Sample Dreams'),
          ),
        ],
      ),
    );
  }

  Widget _buildDreamsList(List<Dream> dreams) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dreams.length,
      itemBuilder: (context, index) {
        final dream = dreams[index];
        return _DreamCard(dream: dream);
      },
    );
  }

  void _showAddDreamDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    int moodRating = 5;
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Dream'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Dream Title',
                    hintText: 'What was your dream about?',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Dream Description',
                    hintText: 'Describe your dream...',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                  items: AppConstants.dreamCategories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Mood: '),
                    Expanded(
                      child: Slider(
                        value: moodRating.toDouble(),
                        min: 1,
                        max: 7,
                        divisions: 6,
                        label: AppConstants.moodLabels[moodRating - 1],
                        onChanged: (value) {
                          setState(() {
                            moodRating = value.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  final dream = Dream.create(
                    title: titleController.text,
                    content: contentController.text,
                    category: selectedCategory,
                    moodRating: moodRating,
                  );

                  ref.read(dreamsProvider.notifier).addDream(dream);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dream saved successfully!'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _addSampleDreams(WidgetRef ref) {
    final sampleDreams = [
      Dream.create(
        title: 'Flying Over Mountains',
        content:
            'I was soaring through clouds above snow-capped peaks. The feeling of freedom was incredible, and I could control my flight with just my thoughts.',
        category: 'Flying Dream',
        moodRating: 6,
        sleepQuality: 4,
        lucidityLevel: 3,
        tags: ['flying', 'mountains', 'freedom', 'lucid'],
      ),
      Dream.create(
        title: 'Lost in a Maze',
        content:
            'I found myself in an endless labyrinth with walls that kept changing. Every turn led to another dead end.',
        category: 'Nightmare',
        moodRating: 2,
        sleepQuality: 2,
        lucidityLevel: 0,
        tags: ['maze', 'lost', 'anxiety'],
      ),
      Dream.create(
        title: 'Tea with My Grandmother',
        content:
            'I was sitting in my grandmother\'s kitchen, having tea and cookies just like when I was a child. She looked exactly as I remember her.',
        category: 'Memory',
        moodRating: 7,
        sleepQuality: 5,
        lucidityLevel: 1,
        tags: ['family', 'childhood', 'grandmother', 'peaceful'],
      ),
    ];

    for (final dream in sampleDreams) {
      ref.read(dreamsProvider.notifier).addDream(dream);
    }
  }
}

class _DreamCard extends ConsumerWidget {
  final Dream dream;

  const _DreamCard({required this.dream});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to dream detail
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dream.title,
                          style: theme.textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dream.formattedDateTime,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'favorite':
                          ref
                              .read(dreamsProvider.notifier)
                              .toggleFavorite(dream);
                          break;
                        case 'delete':
                          _showDeleteDialog(context, ref);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'favorite',
                        child: Row(
                          children: [
                            Icon(
                              dream.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            const SizedBox(width: 8),
                            Text(dream.isFavorite
                                ? 'Remove from favorites'
                                : 'Add to favorites'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Dream content preview
              Text(
                dream.content,
                style: theme.textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Category and mood
              Row(
                children: [
                  if (dream.category != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        dream.category!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Mood indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sentiment_satisfied_alt,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dream.moodLabel,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Favorite indicator
                  if (dream.isFavorite)
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                ],
              ),

              // Tags
              if (dream.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: dream.tags
                      .take(4)
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#$tag',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Dream'),
        content: const Text(
            'Are you sure you want to delete this dream? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(dreamsProvider.notifier).deleteDream(dream.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dream deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
