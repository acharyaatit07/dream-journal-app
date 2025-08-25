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
  final DatabaseService _databaseService = DatabaseService();

  @override
  Future<String> insertDream(Dream dream) =>
      _databaseService.insertDream(dream);

  @override
  Future<List<Dream>> getAllDreams() => _databaseService.getAllDreams();

  @override
  Future<Dream?> getDreamById(String id) => _databaseService.getDreamById(id);

  @override
  Future<void> updateDream(Dream dream) => _databaseService.updateDream(dream);

  @override
  Future<void> deleteDream(String id) => _databaseService.deleteDream(id);

  @override
  Future<List<Dream>> searchDreams(String query) =>
      _databaseService.searchDreams(query);

  @override
  Future<List<Dream>> getDreamsByCategory(String category) =>
      _databaseService.getDreamsByCategory(category);

  @override
  Future<List<Dream>> getFavoriteDreams() =>
      _databaseService.getFavoriteDreams();

  @override
  Future<int> getDreamCount() => _databaseService.getDreamCount();

  @override
  Future<Map<String, int>> getDreamCategoryCounts() =>
      _databaseService.getDreamCategoryCounts();

  @override
  Future<double> getAverageMoodRating() =>
      _databaseService.getAverageMoodRating();
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
