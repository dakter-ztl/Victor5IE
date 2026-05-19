import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'notifier.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoListNotifier notifier = context.watch<TodoListNotifier>();
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (int i = 0; i < notifier.length; i++)
            TodoItem(
              todo: notifier.getTodo(i),
            ),
        ],
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  TodoItem({required this.todo}) : super(key: ObjectKey(todo));
  final Todo todo;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late TextEditingController _controller;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TodoListNotifier notifier = context.watch<TodoListNotifier>();
    return ListTile(
      leading: Checkbox(
        value: widget.todo.checked,
        onChanged: (_) => notifier.changeTodo(widget.todo),
      ),
      title: _editing
          ? TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'todo...'),
              onSubmitted: (val) {
                notifier.updateTodoName(widget.todo, val);
                setState(() => _editing = false);
              },
            )
          : GestureDetector(
              onTap: () => setState(() => _editing = true),
              child: Text(
                widget.todo.name.isEmpty ? 'todo...' : widget.todo.name,
                style: TextStyle(
                  color: widget.todo.checked ? Colors.black45 : null,
                  decoration: widget.todo.checked
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => notifier.deleteTodo(widget.todo),
      ),
    );
  }
}