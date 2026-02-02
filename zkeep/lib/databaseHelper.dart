import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.init();
  static Database? databaseInstance;

  DatabaseHelper.init();

  Future<Database> get database async {
    if (databaseInstance != null) return databaseInstance!;
    databaseInstance = await initDb('zkeep.db');
    return databaseInstance!;
  }

  Future<Database> initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: createDb);
  }

  Future createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT
      )
    ''');
  }

  // crea nuovo elemento
  Future<int> createItem(String title, String content) async {
    final db = await instance.database;
    return await db.insert('items', {'title': title, 'content': content});
  }

  // leggi tutti gli elementi
  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await instance.database;
    return await db.query('items', orderBy: "id DESC");
  }

  // elimina elemento
  Future<int> deleteItem(int id) async {
    final db = await instance.database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}