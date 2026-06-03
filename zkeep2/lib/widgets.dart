import 'package:flutter/material.dart';
import 'model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({super.key, required this.note, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        onTap: onTap,
        title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          note.description.isNotEmpty 
            ? note.description 
            : "Tocca per gestire i promemoria",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onTodoChanged;
  final Function(Todo) onTodoDelete;
  final Function(Todo) onTodoEdit;

  const TodoItem({
    super.key, 
    required this.todo, 
    required this.onTodoChanged, 
    required this.onTodoDelete, 
    required this.onTodoEdit
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.checked, 
        onChanged: (context) => onTodoChanged(todo)
      ),
      title: Text(
        todo.name, 
        style: todo.checked ? const TextStyle(decoration: TextDecoration.lineThrough) : null
      ),
      onTap: () => onTodoEdit(todo),
      trailing: IconButton(
        icon: const Icon(Icons.delete), 
        onPressed: () => onTodoDelete(todo)
      ),
    );
  }
}