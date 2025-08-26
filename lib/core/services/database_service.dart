// Replace your lib/core/services/database_service.dart with this:

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static const String _databaseName = 'dream_journal.db';
  static const int _databaseVersion = 4; // Bump version
  static const String tableDreams = 'dreams';

  DatabaseService._privateConstructor();
  static final DatabaseService _instance =
      DatabaseService._privateConstructor();
  static DatabaseService get instance => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    // For debugging
    debugPrint('🗄️ Database path: $path');
    debugPrint('🌐 Platform: ${kIsWeb ? "Web" : "Mobile"}');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: _onOpen,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('📝 Creating new database with version $version');

    await db.execute('''
      CREATE TABLE $tableDreams (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        category TEXT,
        mood_rating INTEGER DEFAULT 5,
        sleep_quality INTEGER DEFAULT 5,
        lucidity_level INTEGER DEFAULT 0,
        tags TEXT,
        is_favorite INTEGER DEFAULT 0,
        bed_time TEXT,
        wake_time TEXT,
        dream_vividness INTEGER DEFAULT 5
      )
    ''');

    debugPrint('✅ Database table created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('🔄 Upgrading database from $oldVersion to $newVersion');

    // Handle different upgrade paths
    if (oldVersion < 4) {
      // Check what columns exist
      final tableInfo = await db.rawQuery('PRAGMA table_info($tableDreams)');
      final existingColumns =
          tableInfo.map((col) => col['name'] as String).toSet();

      debugPrint('📋 Existing columns: $existingColumns');

      // Add missing columns
      final requiredColumns = {
        'bed_time': 'TEXT',
        'wake_time': 'TEXT',
        'dream_vividness': 'INTEGER DEFAULT 5',
      };

      for (final entry in requiredColumns.entries) {
        if (!existingColumns.contains(entry.key)) {
          try {
            await db.execute(
                'ALTER TABLE $tableDreams ADD COLUMN ${entry.key} ${entry.value}');
            debugPrint('✅ Added column: ${entry.key}');
          } catch (e) {
            debugPrint('❌ Failed to add ${entry.key}: $e');

            // If ALTER TABLE fails, recreate the table
            await _recreateTable(db);
            break;
          }
        }
      }
    }
  }

  Future<void> _onOpen(Database db) async {
    debugPrint('🔓 Database opened successfully');

    // Verify table structure
    final tableInfo = await db.rawQuery('PRAGMA table_info($tableDreams)');
    final columns = tableInfo.map((col) => col['name'] as String).toList();
    debugPrint('📋 Current table columns: $columns');

    // Check if all required columns exist
    const requiredColumns = [
      'id',
      'title',
      'content',
      'created_at',
      'updated_at',
      'category',
      'mood_rating',
      'sleep_quality',
      'lucidity_level',
      'tags',
      'is_favorite',
      'bed_time',
      'wake_time',
      'dream_vividness'
    ];

    final missingColumns =
        requiredColumns.where((col) => !columns.contains(col)).toList();

    if (missingColumns.isNotEmpty) {
      debugPrint('⚠️ Missing columns detected: $missingColumns');
      // The onUpgrade should have handled this, but let's be safe
      await _recreateTable(db);
    }
  }

  Future<void> _recreateTable(Database db) async {
    debugPrint('🔨 Recreating table with correct schema');

    // Backup existing data
    List<Map<String, dynamic>> existingData = [];
    try {
      existingData = await db.query(tableDreams);
      debugPrint('💾 Backed up ${existingData.length} records');
    } catch (e) {
      debugPrint('⚠️ Could not backup data: $e');
    }

    // Drop and recreate table
    await db.execute('DROP TABLE IF EXISTS $tableDreams');
    await _onCreate(db, _databaseVersion);

    // Restore data
    for (final record in existingData) {
      try {
        // Only insert columns that exist in the new schema
        final cleanRecord = <String, dynamic>{};
        const validColumns = [
          'id',
          'title',
          'content',
          'created_at',
          'updated_at',
          'category',
          'mood_rating',
          'sleep_quality',
          'lucidity_level',
          'tags',
          'is_favorite'
        ];

        for (final col in validColumns) {
          if (record.containsKey(col)) {
            cleanRecord[col] = record[col];
          }
        }

        await db.insert(tableDreams, cleanRecord);
      } catch (e) {
        debugPrint('⚠️ Could not restore record: $e');
      }
    }

    debugPrint('✅ Table recreation completed');
  }

  // CRUD operations
  Future<int> insertDream(Map<String, dynamic> dream) async {
    final db = await database;
    return await db.insert(tableDreams, dream,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllDreams() async {
    final db = await database;
    return await db.query(tableDreams, orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>?> getDreamById(String id) async {
    final db = await database;
    final results =
        await db.query(tableDreams, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateDream(Map<String, dynamic> dream) async {
    final db = await database;
    return await db
        .update(tableDreams, dream, where: 'id = ?', whereArgs: [dream['id']]);
  }

  Future<int> deleteDream(String id) async {
    final db = await database;
    return await db.delete(tableDreams, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
