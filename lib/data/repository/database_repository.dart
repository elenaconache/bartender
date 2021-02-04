import 'dart:async';

import 'package:bartender/data/models/drink.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bartender/data/database_helper.dart';

class DatabaseRepository {
  DatabaseRepository();

  Future<void> insertFavoriteDrink(Drink drink) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert(
      DatabaseHelper.drinksTable,
      drink.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Drink>> getFavoriteDrinks() async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.drinksTable);
    return List.generate(maps.length, (i) {
      return Drink(
        id: maps[i][DatabaseHelper.columnId],
        name: maps[i][DatabaseHelper.columnName],
        imageURL: maps[i][DatabaseHelper.columnImageUrl],
        instructions: maps[i][DatabaseHelper.columnInstructions],
        category: maps[i][DatabaseHelper.columnCategory],
        glass: maps[i][DatabaseHelper.columnGlass],
        alcoholic: maps[i][DatabaseHelper.columnAlcoholic],
        mainIngredient: maps[i][DatabaseHelper.columnMainIngredient],
      );
    });
  }

  Future<bool> isFavorite(String id) async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.drinksTable,
        where: '${DatabaseHelper.columnId} = ?',
        whereArgs: [id]);
    return maps.isNotEmpty;
  }

  Future<void> deleteDrink(String id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete(
      DatabaseHelper.drinksTable,
      where: "${DatabaseHelper.columnId} = ?",
      whereArgs: [id],
    );
  }
}
