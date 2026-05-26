import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL
    );
    ''');

    await db.execute('''
    CREATE TABLE todos (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      note_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      checked INTEGER NOT NULL,
      FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE
    );
    ''');
  }

  static Future<List<Note>> getNotes() async {
    Database db = await database;
    final List<Map<String, dynamic>> result = await db.query('notes');
    if (result.isEmpty) {
      return <Note>[];
    }
    return result.map((row) => Note.fromMap(row)).toList();
  }

  static Future<void> insertNote(Note note) async {
    Database db = await database;
    await db.insert('notes', note.toMap());
  }

  static Future<void> deleteNote(Note note) async {
    Database db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
  }

  static Future<List<Todo>> getAllTodos() async {
    Database db = await database;
    final List<Map<String, dynamic>> result = await db.query('todos');
    return result.map((row) => Todo.fromMap(row)).toList();
  }

  static Future<List<Todo>> getTodos(int noteId) async {
    Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'todos',
      where: 'note_id = ?',
      whereArgs: [noteId],
    );
    if (result.isEmpty) {
      return <Todo>[];
    }
    return result.map((row) => Todo.fromMap(row)).toList();
  }

  static Future<void> insertTodo(Todo todo) async {
    Database db = await database;
    await db.insert('todos', todo.toMap());
  }

  static Future<void> updateTodo(Todo todo) async {
    Database db = await database;
    await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  static Future<void> deleteTodo(Todo todo) async {
    Database db = await database;
    await db.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
  }
}