import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/combo.dart';

class FruitDatabase {
  static final FruitDatabase instance = FruitDatabase._init();
  static Database? _database;

  FruitDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('fruit.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // await deleteDatabase(path); //////////////////
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE combos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        image TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE basket (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        image TEXT NOT NULL,
        count INTEGER NOT NULL DEFAULT 1
      );
    ''');

    await db.insert('combos', {
      'name': 'Honey lime combo',
      'image': 'assets/images/honey_lime.png',
      'price': 2000,
    });

    await db.insert('combos', {
      'name': 'Berry mango combo',
      'image': 'assets/images/berry_mango.png',
      'price': 2500,
    });

    await db.insert('combos', {
      'name': 'Tropical fruit salad',
      'image': 'assets/images/tropical_fruit_salad.png',
      'price': 3000,
    });

    await db.insert('combos', {
      'name': 'Quinoa fruit salad',
      'image': 'assets/images/quinoa_fruit_salad.png',
      'price': 10000,
    });

    await db.insert('combos', {
      'name': 'Tropical fruit salad',
      'image': 'assets/images/tropical_fruit_salad.png',
      'price': 10000,
    });

    await db.insert('combos', {
      'name': 'Melon fruit salad',
      'image': 'assets/images/melon_fruit_salad.png',
      'price': 10000,
    });
  }

  delete(String table) async {
    final db = await instance.database;
    await db.delete(table);
  }

  // Insert a combo into the basket
  Future<void> addToBasket(Combo combo) async {
    final db = await instance.database;
    await db.insert('basket', combo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all combos from the basket
  Future<List<Combo>> getBasket() async {
    final db = await instance.database;
    final result = await db.query('basket');

    return result.map((json) => Combo.fromJson(json)).toList();
  }

  // Remove a combo from the basket
  Future<void> removeFromBasket(int id) async {
    final db = await instance.database;
    await db.delete('basket', where: 'id = ?', whereArgs: [id]);
  }

  // Insert a combo into the basket
  Future<void> addCombo(Combo combo) async {
    final db = await instance.database;
    await db.insert('combos', combo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all combos from the basket
  Future<List<Combo>> getCombos() async {
    final db = await instance.database;
    final result = await db.query('combos');

    return result.map((json) => Combo.fromJson(json)).toList();
  }

  // Remove a combo from the basket
  Future<void> removeCombo(int id) async {
    final db = await instance.database;
    await db.delete('combos', where: 'id = ?', whereArgs: [id]);
  }

  Future<Combo?> getComboFromBasket(int comboId) async {
    final db = await instance.database;
    final result = await db.query(
      'basket',
      where: 'id = ?',
      whereArgs: [comboId],
    );

    if (result.isNotEmpty) {
      return Combo.fromJson(result.first);
    } else {
      return null; // Combo not found
    }
  }

  Future<void> updateComboCount(int comboId, int newCount) async {
    final db = await instance.database;
    await db.update(
      'basket',
      {'count': newCount},
      where: 'id = ?',
      whereArgs: [comboId],
    );
  }

  Future<void> updateOrRemoveComboFromBasket(int comboId) async {
    final db = await instance.database;

    final result = await db.query(
      'basket',
      where: 'id = ?',
      whereArgs: [comboId],
    );

    if (result.isNotEmpty) {
      int currentCount = result.first['count'] as int;

      if (currentCount > 1) {
        // If count is more than 1, decrement it
        await db.update(
          'basket',
          {'count': currentCount - 1},
          where: 'id = ?',
          whereArgs: [comboId],
        );
      } else {
        // If count is 1, remove the item
        await db.delete(
          'basket',
          where: 'id = ?',
          whereArgs: [comboId],
        );
      }
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
