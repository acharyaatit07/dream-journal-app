// lib/core/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../../features/dreams/models/dream.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.dreamsTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        dream_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        mood_rating INTEGER NOT NULL DEFAULT 5,
        sleep_quality INTEGER NOT NULL DEFAULT 3,
        lucidity_level INTEGER NOT NULL DEFAULT 0,
        tags TEXT,
        category TEXT,
        audio_file_path TEXT,
        is_favorite INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // CRUD Operations for Dreams
  Future<String> insertDream(Dream dream) async {
    final db = await database;
    await db.insert(
      AppConstants.dreamsTable,
      dream.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return dream.id;
  }

  Future<List<Dream>> getAllDreams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.dreamsTable,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Dream.fromMap(maps[i]);
    });
  }

  Future<Dream?> getDreamById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.dreamsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Dream.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateDream(Dream dream) async {
    final db = await database;
    await db.update(
      AppConstants.dreamsTable,
      dream.toMap(),
      where: 'id = ?',
      whereArgs: [dream.id],
    );
  }

  Future<void> deleteDream(String id) async {
    final db = await database;
    await db.delete(
      AppConstants.dreamsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Search dreams
  Future<List<Dream>> searchDreams(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.dreamsTable,
      where: 'title LIKE ? OR content LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Dream.fromMap(maps[i]);
    });
  }

  // Get dreams by category
  Future<List<Dream>> getDreamsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.dreamsTable,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Dream.fromMap(maps[i]);
    });
  }

  // Get favorite dreams
  Future<List<Dream>> getFavoriteDreams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.dreamsTable,
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Dream.fromMap(maps[i]);
    });
  }

  // Analytics queries
  Future<int> getDreamCount() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.dreamsTable}');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, int>> getDreamCategoryCounts() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT category, COUNT(*) as count 
      FROM ${AppConstants.dreamsTable} 
      WHERE category IS NOT NULL 
      GROUP BY category
    ''');

    Map<String, int> categoryCounts = {};
    for (var row in result) {
      categoryCounts[row['category']] = row['count'];
    }
    return categoryCounts;
  }

  Future<double> getAverageMoodRating() async {
    final db = await database;
    final result = await db
        .rawQuery('SELECT AVG(mood_rating) FROM ${AppConstants.dreamsTable}');
    return (result.first.values.first as double?) ?? 5.0;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Delete database (for testing)
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
