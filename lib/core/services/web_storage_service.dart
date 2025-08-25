// lib/core/services/web_storage_service.dart

import '../../features/dreams/models/dream.dart';

class WebStorageService {
  static final WebStorageService _instance = WebStorageService._internal();
  factory WebStorageService() => _instance;
  WebStorageService._internal();

  final List<Dream> _dreams = [];

  Future<String> insertDream(Dream dream) async {
    _dreams.add(dream);
    return dream.id;
  }

  Future<List<Dream>> getAllDreams() async {
    final sortedDreams = List<Dream>.from(_dreams);
    sortedDreams.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedDreams;
  }

  Future<Dream?> getDreamById(String id) async {
    try {
      return _dreams.firstWhere((dream) => dream.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateDream(Dream dream) async {
    final index = _dreams.indexWhere((d) => d.id == dream.id);
    if (index != -1) {
      _dreams[index] = dream;
    }
  }

  Future<void> deleteDream(String id) async {
    _dreams.removeWhere((dream) => dream.id == id);
  }

  Future<List<Dream>> searchDreams(String query) async {
    final lowercaseQuery = query.toLowerCase();
    return _dreams.where((dream) {
      return dream.title.toLowerCase().contains(lowercaseQuery) ||
          dream.content.toLowerCase().contains(lowercaseQuery) ||
          dream.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Future<List<Dream>> getDreamsByCategory(String category) async {
    return _dreams.where((dream) => dream.category == category).toList();
  }

  Future<List<Dream>> getFavoriteDreams() async {
    return _dreams.where((dream) => dream.isFavorite).toList();
  }

  Future<int> getDreamCount() async {
    return _dreams.length;
  }

  Future<Map<String, int>> getDreamCategoryCounts() async {
    Map<String, int> categoryCounts = {};
    for (var dream in _dreams) {
      if (dream.category != null) {
        categoryCounts[dream.category!] =
            (categoryCounts[dream.category!] ?? 0) + 1;
      }
    }
    return categoryCounts;
  }

  Future<double> getAverageMoodRating() async {
    if (_dreams.isEmpty) return 5.0;
    final total = _dreams.fold(0, (sum, dream) => sum + dream.moodRating);
    return total / _dreams.length;
  }
}
