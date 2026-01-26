import 'package:flutter/widgets.dart';

import 'model.dart';

class NoteListNotifier with ChangeNotifier {
  final _notes = <Note>[];

  int get length => _notes.length;

  void addNote() {
    _notes.add(Note(title: 'Nuova Nota', todos: []));
    notifyListeners();
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  void addTodoToNote(Note note, String task) {
    note.todos.add(Todo(name: task, checked: false));
    notifyListeners();
  }

  void updateNoteTitle(Note note, String newTitle) {
    note.title = newTitle;
  }

  void toggleTodo(Todo todo) {
    todo.checked = !todo.checked;
    notifyListeners();
  }

  Note getNote(int i) => _notes[i];
}
