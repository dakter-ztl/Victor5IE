import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model.dart';
import 'notifier.dart';

class NoteCard extends StatelessWidget {
  NoteCard({required this.note}) : super(key: ObjectKey(note));

  final Note note;

  @override
  Widget build(BuildContext context) {
    final NoteListNotifier notifier = context.watch<NoteListNotifier>();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: note.title),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Titolo'),
              onSubmitted: (val) => note.title = val,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: note.title),
                    decoration: const InputDecoration(hintText: 'Titolo'),
                    onChanged: (val) => context
                        .read<NoteListNotifier>()
                        .updateNoteTitle(note, val),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    notifier.deleteNote(note);
                  },
                ),
              ],
            ),
            ...note.todos
                .map((todo) => Row(
                      children: [
                        Checkbox(
                          value: todo.checked,
                          onChanged: (bool? value) => notifier.toggleTodo(todo),
                        ),
                        Expanded(
                          child: TextField(
                              controller: todo.controller,
                              style: TextStyle(
                                decoration: todo.checked
                                    ? TextDecoration.lineThrough
                                    : null,
                              )),
                        ),
                      ],
                    ))
                .toList(),
            TextButton.icon(
              onPressed: () {
                context
                    .read<NoteListNotifier>()
                    .addTodoToNote(note, 'Nuovo elemento');
                ;
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Aggiungi To Do'),
            ),
          ],
        ),
      ),
    );
  }
}
