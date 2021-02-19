import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "bartender_database.db";
  static final _databaseVersion = 1;

  static final drinksTable = 'drinks';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnImageUrl = 'imageURL';
  static final columnInstructions = 'instructions';
  static final columnCategory = 'category';
  static final columnGlass = 'glass';
  static final columnAlcoholic = 'alcoholic';
  static final columnMainIngredient = 'mainIngredient';
  static final count = 'c';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $drinksTable($columnId TEXT PRIMARY KEY,
        $columnName TEXT NOT NULL,$columnImageUrl TEXT NOT NULL,
        $columnInstructions TEXT NOT NULL,$columnCategory TEXT NOT NULL,
        $columnGlass TEXT NOT NULL,$columnAlcoholic TEXT NOT NULL,
        $columnMainIngredient TEXT NOT NULL)''');
  }
}
