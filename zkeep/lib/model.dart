class Todo {
  Todo({required this.name, required this.checked});
  String name;
  bool checked;

  get controller => null;
}

class Note {
  Note({required this.title, required this.todos});
  String title;
  final List<Todo> todos;
}