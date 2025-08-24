// lib/features/dreams/services/dreams_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/database_service.dart';
import '../models/dream.dart';

// Database service provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// Dreams list provider
final dreamsProvider =
    StateNotifierProvider<DreamsNotifier, AsyncValue<List<Dream>>>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return DreamsNotifier(databaseService);
});

// Dreams notifier class
class DreamsNotifier extends StateNotifier<AsyncValue<List<Dream>>> {
  final DatabaseService _databaseService;

  DreamsNotifier(this._databaseService) : super(const AsyncValue.loading()) {
    loadDreams();
  }

  Future<void> loadDreams() async {
    try {
      state = const AsyncValue.loading();
      final dreams = await _databaseService.getAllDreams();
      state = AsyncValue.data(dreams);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addDream(Dream dream) async {
    try {
      await _databaseService.insertDream(dream);
      await loadDreams(); // Reload all dreams
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateDream(Dream dream) async {
    try {
      await _databaseService.updateDream(dream);
      await loadDreams(); // Reload all dreams
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteDream(String id) async {
    try {
      await _databaseService.deleteDream(id);
      await loadDreams(); // Reload all dreams
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleFavorite(Dream dream) async {
    final updatedDream = dream.copyWith(isFavorite: !dream.isFavorite);
    await updateDream(updatedDream);
  }

  Future<List<Dream>> searchDreams(String query) async {
    return await _databaseService.searchDreams(query);
  }

  Future<List<Dream>> getDreamsByCategory(String category) async {
    return await _databaseService.getDreamsByCategory(category);
  }
}

// Individual dream provider
final dreamProvider =
    FutureProvider.family<Dream?, String>((ref, dreamId) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getDreamById(dreamId);
});

// Dream statistics provider
final dreamStatsProvider = FutureProvider<DreamStats>((ref) async {
  final databaseService = ref.watch(databaseServiceProvider);

  final totalDreams = await databaseService.getDreamCount();
  final categoryCounts = await databaseService.getDreamCategoryCounts();
  final averageMood = await databaseService.getAverageMoodRating();

  return DreamStats(
    totalDreams: totalDreams,
    categoryCounts: categoryCounts,
    averageMood: averageMood,
  );
});

// Dream statistics model
class DreamStats {
  final int totalDreams;
  final Map<String, int> categoryCounts;
  final double averageMood;

  const DreamStats({
    required this.totalDreams,
    required this.categoryCounts,
    required this.averageMood,
  });
}
