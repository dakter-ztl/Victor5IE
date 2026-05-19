import 'package:flutter/material.dart';

import 'helper.dart';
import 'model.dart';
import 'widgets.dart';

class NotePage extends StatefulWidget {
  final Note note;

  const NotePage({Key? key, required this.note}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool _isLoading = true;
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    if (widget.note.id != null) {
      _todos = await DatabaseHelper.getTodos(widget.note.id!);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addTodo() async {
    final nextIndex = _todos.length + 1;
    final todo = Todo(
      id: null,
      noteId: widget.note.id,
      name: 'Nuovo todo $nextIndex',
    );
    final insertedId = await DatabaseHelper.insertTodo(todo);

    setState(() {
      _todos.add(Todo(
        id: insertedId,
        noteId: todo.noteId,
        name: todo.name,
        checked: todo.checked,
      ));
    });
  }

  Future<void> _toggleTodoDone(Todo todo) async {
    final updated = Todo(
      id: todo.id,
      noteId: todo.noteId,
      name: todo.name,
      checked: !todo.checked,
    );
    await DatabaseHelper.updateTodo(updated);

    setState(() {
      final index = _todos.indexWhere((element) => element.id == todo.id);
      if (index != -1) {
        _todos[index] = updated;
      }
    });
  }

  Future<void> _editTodoTitle(Todo todo) async {
    final controller = TextEditingController(text: todo.name);
    final editedTitle = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifica todo'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Titolo todo'),
            onSubmitted: (value) => Navigator.of(context).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Salva'),
            ),
          ],
        );
      },
    );

    if (editedTitle != null && editedTitle.trim().isNotEmpty) {
      final updated = Todo(
        id: todo.id,
        noteId: todo.noteId,
        name: editedTitle.trim(),
        checked: todo.checked,
      );
      await DatabaseHelper.updateTodo(updated);

      setState(() {
        final index = _todos.indexWhere((element) => element.id == todo.id);
        if (index != -1) {
          _todos[index] = updated;
        }
      });
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    if (todo.id == null) return;
    await DatabaseHelper.deleteTodo(todo);
    setState(() {
      _todos.removeWhere((element) => element.id == todo.id);
    });
  }

  Future<void> _showTodoActions(Todo todo) async {
    final action = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Todo'),
          content: const Text('Scegli un\'azione per questo todo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop('delete'),
              child: const Text('Elimina'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('edit'),
              child: const Text('Modifica'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
          ],
        );
      },
    );

    if (action == 'edit') {
      await _editTodoTitle(todo);
    } else if (action == 'delete') {
      await _deleteTodo(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title.isEmpty ? 'Nota' : widget.note.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todos.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Nessun todo. Tocca il pulsante + per aggiungere un nuovo todo.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
                    final todo = _todos[index];
                    return TodoItem(
                      todo: todo,
                      onTodoChanged: (_) => _toggleTodoDone(todo),
                      onTodoDelete: (_) => _showTodoActions(todo),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Nuovo todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
