import 'dart:async';
import 'package:flower_vault/models/flower.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'flower_vault.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE favourites (
            id TEXT PRIMARY KEY,
            nama TEXT,
            kategori TEXT,
            deskripsi TEXT,
            tanggal TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> addFavourite(Flower flower) async {
    final db = await database;
    await db.insert(
      'favourites',
      {
        'id': flower.docId,
        'nama': flower.nama,
        'kategori': flower.kategori,
        'deskripsi': flower.deskripsi,
        'tanggal': flower.tanggal.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavourite(String id) async {
    final db = await database;
    await db.delete(
      'favourites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Flower>> getFavourites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favourites');

    return List.generate(maps.length, (i) {
      return Flower(
        docId: maps[i]['id'],
        nama: maps[i]['nama'],
        kategori: maps[i]['kategori'],
        deskripsi: maps[i]['deskripsi'],
        tanggal: DateTime.parse(maps[i]['tanggal']),
        uid: '', // Tidak digunakan di SQLite
      );
    });
  }

  Future<bool> isFavourite(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favourites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}
