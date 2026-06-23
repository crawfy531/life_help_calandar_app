
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {



    await db.execute('''
      CREATE TABLE goals(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        title Text,
        start_date TEXT,
        time_of_day TEXT,
        end_date TEXT,
        frequency_amount INTEGER,
        frequency_time TEXT,
        goal_content TEXT,
        goal_complete INTEGER,
        parent_id INTEGER,
        FOREIGN KEY (parent_id) REFERENCES goals(id) ON DELETE CASCADE)
    ''');



    await db.execute(
'''CREATE TABLE nutrition(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        serving_number INTEGER,
        food TEXT,
        food_category TEXT,
        ingredients TEXT,
        serving_size INTEGER,
        serving_unit TEXT,
        serving_description TEXT,
        nutrients TEXT)'''
    );




    await db.execute(
        '''CREATE TABLE emotion(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        datetime TEXT,
        emotion_name TEXT,
        emotion_description TEXT,
        emotion_icon TEXT,
        emotion_rank INTEGER
        )''');




    await db.execute
      (
        '''CREATE TABLE finances (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        finance_category TEXT,
        datetime TEXT,
        finance_amount INTEGER,
        finance_note TEXT
      )'''
    );
  }
}



Future<void> deleteAppDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'my_database.db');
  await deleteDatabase(path);}

Future<void> deleteItem(String tableName, int id) async {
  final db = await DatabaseHelper().database;
  await db.delete(
    tableName,
    where: 'id = ?',
    whereArgs: [id],
  );
}