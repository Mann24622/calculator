import 'package:calculator/model/calculation.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'calculator.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT, equation TEXT, result TEXT)',
        );
      },
    );
  }

  Future<void> insertCalculation(CalculationHistory calculation) async {
    final db = await database;
    await db.insert(
      'history',
      calculation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CalculationHistory>> getCalculations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('history');

    return List.generate(maps.length, (i) {
      return CalculationHistory.fromMap(maps[i]);
    });
  }

  Future<void> deleteCalculation(int id) async {
    final db = await database;
    await db.delete(
      'history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
