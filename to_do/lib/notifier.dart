import 'package:flutter/widgets.dart';
import 'model.dart';

class TodoListNotifier with ChangeNotifier {
  final _todos = <Todo>[];

  int get length => _todos.length;

  void addTodo() {
    _todos.add(Todo(name: ''));
    notifyListeners();
  }

  void changeTodo(Todo todo) {
    todo.checked = !todo.checked;
    notifyListeners();
  }

  void deleteTodo(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }

  void updateTodoName(Todo todo, String name) {
    todo.name = name;
  }

  Todo getTodo(int i) => _todos[i];
}