import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class DatabaseHelper {
  // apre (o crea) il database
  static Future<Database> _open() async {
    String path = join(await getDatabasesPath(), 'zkeep.db');
    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  // crea le due tabelle al primo avvio
  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id      INTEGER NOT NULL PRIMARY KEY,
        title   TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE todos (
        id       INTEGER NOT NULL PRIMARY KEY,
        note_id  INTEGER NOT NULL,
        name     TEXT NOT NULL,
        checked  INTEGER NOT NULL,
        FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE
      );
    ''');
  }

  // ---------- NOTE ----------

  static Future<List<Note>> getNotes() async {
    Database db = await _open();
    final List<Map<String, dynamic>> result = await db.query('notes');
    return result.map((row) => Note.fromMap(row)).toList();
  }

  static Future<int> insertNote(Note note) async {
    Database db = await _open();
    return await db.insert('notes', note.toMap());
  }

  static Future<void> deleteNote(Note note) async {
    Database db = await _open();
    await db.delete('notes', where: 'id = ?', whereArgs: [note.id]);
  }

  // ---------- TODO ----------

  static Future<List<Todo>> getTodos(int noteId) async {
    Database db = await _open();
    final List<Map<String, dynamic>> result = await db.query(
      'todos',
      where: 'note_id = ?',
      whereArgs: [noteId],
    );
    return result.map((row) => Todo.fromMap(row)).toList();
  }

  static Future<int> insertTodo(Todo todo) async {
    Database db = await _open();
    return await db.insert('todos', todo.toMap());
  }

  static Future<void> updateTodo(Todo todo) async {
    Database db = await _open();
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static Future<void> deleteTodo(Todo todo) async {
    Database db = await _open();
    await db.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
  }
}
