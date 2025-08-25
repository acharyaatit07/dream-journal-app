// lib/features/dreams/services/dreams_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/storage_service.dart';
import '../../analytics/models/dream_analytics.dart';
import '../../analytics/services/analytics_service.dart';
import '../models/dream.dart';

// Storage service provider - uses platform-appropriate storage
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageServiceFactory.createStorageService();
});

// Dreams list provider
final dreamsProvider =
    StateNotifierProvider<DreamsNotifier, AsyncValue<List<Dream>>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return DreamsNotifier(storageService);
});

// Dreams notifier class
class DreamsNotifier extends StateNotifier<AsyncValue<List<Dream>>> {
  final StorageService _storageService;

  DreamsNotifier(this._storageService) : super(const AsyncValue.loading()) {
    loadDreams();
  }

  Future<void> loadDreams() async {
    try {
      state = const AsyncValue.loading();
      final dreams = await _storageService.getAllDreams();
      state = AsyncValue.data(dreams);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addDream(Dream dream) async {
    try {
      await _storageService.insertDream(dream);
      await loadDreams(); // Reload all dreams
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateDream(Dream dream) async {
    try {
      await _storageService.updateDream(dream);
      await loadDreams(); // Reload all dreams
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteDream(String id) async {
    try {
      await _storageService.deleteDream(id);
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
    return await _storageService.searchDreams(query);
  }

  Future<List<Dream>> getDreamsByCategory(String category) async {
    return await _storageService.getDreamsByCategory(category);
  }
}

// Individual dream provider
final dreamProvider =
    FutureProvider.family<Dream?, String>((ref, dreamId) async {
  final storageService = ref.watch(storageServiceProvider);
  return await storageService.getDreamById(dreamId);
});

// Dream statistics provider
final dreamStatsProvider = FutureProvider<DreamStats>((ref) async {
  final storageService = ref.watch(storageServiceProvider);

  final totalDreams = await storageService.getDreamCount();
  final categoryCounts = await storageService.getDreamCategoryCounts();
  final averageMood = await storageService.getAverageMoodRating();

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

// Analytics provider - calculates analytics from current dreams
final analyticsProvider = Provider<AsyncValue<DreamAnalytics>>((ref) {
  final dreamsAsync = ref.watch(dreamsProvider);

  return dreamsAsync.when(
    data: (dreams) {
      final analytics = AnalyticsService.calculateAnalytics(dreams);
      return AsyncValue.data(analytics);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
