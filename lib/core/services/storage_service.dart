// lib/core/services/storage_service.dart

import 'package:flutter/foundation.dart' show kIsWeb;
import '../../features/dreams/models/dream.dart';
import 'database_service.dart';
import 'web_storage_service.dart';

abstract class StorageService {
  Future<String> insertDream(Dream dream);
  Future<List<Dream>> getAllDreams();
  Future<Dream?> getDreamById(String id);
  Future<void> updateDream(Dream dream);
  Future<void> deleteDream(String id);
  Future<List<Dream>> searchDreams(String query);
  Future<List<Dream>> getDreamsByCategory(String category);
  Future<List<Dream>> getFavoriteDreams();
  Future<int> getDreamCount();
  Future<Map<String, int>> getDreamCategoryCounts();
  Future<double> getAverageMoodRating();
}

class StorageServiceFactory {
  static StorageService createStorageService() {
    if (kIsWeb) {
      return WebStorageServiceImpl();
    } else {
      return DatabaseServiceImpl();
    }
  }
}

class DatabaseServiceImpl implements StorageService {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Future<String> insertDream(Dream dream) async {
    // Convert the int result to String (the dream ID)
    await _databaseService.insertDream(dream.toMap());
    return dream.id; // Return the dream ID as String
  }

  @override
  Future<List<Dream>> getAllDreams() async {
    final dreamsData = await _databaseService.getAllDreams();
    return dreamsData.map((data) => Dream.fromMap(data)).toList();
  }

  @override
  Future<Dream?> getDreamById(String id) async {
    final dreamData = await _databaseService.getDreamById(id);
    return dreamData != null ? Dream.fromMap(dreamData) : null;
  }

  @override
  Future<void> updateDream(Dream dream) async {
    await _databaseService.updateDream(dream.toMap());
  }

  @override
  Future<void> deleteDream(String id) async {
    await _databaseService.deleteDream(id);
  }

  @override
  Future<List<Dream>> searchDreams(String query) async {
    // Implement search using the database service
    final allDreams = await getAllDreams();
    return allDreams.where((dream) {
      return dream.title.toLowerCase().contains(query.toLowerCase()) ||
          dream.content.toLowerCase().contains(query.toLowerCase()) ||
          (dream.category?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          dream.tags
              .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  @override
  Future<List<Dream>> getDreamsByCategory(String category) async {
    final allDreams = await getAllDreams();
    return allDreams.where((dream) => dream.category == category).toList();
  }

  @override
  Future<List<Dream>> getFavoriteDreams() async {
    final allDreams = await getAllDreams();
    return allDreams.where((dream) => dream.isFavorite).toList();
  }

  @override
  Future<int> getDreamCount() async {
    final dreams = await getAllDreams();
    return dreams.length;
  }

  @override
  Future<Map<String, int>> getDreamCategoryCounts() async {
    final dreams = await getAllDreams();
    final Map<String, int> categoryCounts = {};

    for (final dream in dreams) {
      final category = dream.category ?? 'Uncategorized';
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }

    return categoryCounts;
  }

  @override
  Future<double> getAverageMoodRating() async {
    final dreams = await getAllDreams();
    if (dreams.isEmpty) return 0.0;

    final totalMood =
        dreams.fold<int>(0, (sum, dream) => sum + dream.moodRating);
    return totalMood / dreams.length;
  }
}

class WebStorageServiceImpl implements StorageService {
  final WebStorageService _webStorageService = WebStorageService();

  @override
  Future<String> insertDream(Dream dream) =>
      _webStorageService.insertDream(dream);

  @override
  Future<List<Dream>> getAllDreams() => _webStorageService.getAllDreams();

  @override
  Future<Dream?> getDreamById(String id) => _webStorageService.getDreamById(id);

  @override
  Future<void> updateDream(Dream dream) =>
      _webStorageService.updateDream(dream);

  @override
  Future<void> deleteDream(String id) => _webStorageService.deleteDream(id);

  @override
  Future<List<Dream>> searchDreams(String query) =>
      _webStorageService.searchDreams(query);

  @override
  Future<List<Dream>> getDreamsByCategory(String category) =>
      _webStorageService.getDreamsByCategory(category);

  @override
  Future<List<Dream>> getFavoriteDreams() =>
      _webStorageService.getFavoriteDreams();

  @override
  Future<int> getDreamCount() => _webStorageService.getDreamCount();

  @override
  Future<Map<String, int>> getDreamCategoryCounts() =>
      _webStorageService.getDreamCategoryCounts();

  @override
  Future<double> getAverageMoodRating() =>
      _webStorageService.getAverageMoodRating();
}
