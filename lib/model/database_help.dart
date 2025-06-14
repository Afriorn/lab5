// lib/data/database_helper.dart
import 'package:lab5/model/acceleration_record.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = 'acceleration.db';
  static const _databaseVersion = 1;
  static const table = 'records';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/$_databaseName';
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        initial_velocity REAL NOT NULL,
        final_velocity REAL NOT NULL,
        time REAL NOT NULL,
        acceleration REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertRecord(AccelerationRecord record) async {
    final db = await database;
    return await db.insert(table, record.toMap());
  }

  Future<List<AccelerationRecord>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) {
      return AccelerationRecord.fromMap(maps[i]);
    });
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}