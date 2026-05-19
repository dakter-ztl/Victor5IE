import 'package:flutter/material.dart';

import 'helper.dart';
import 'model.dart';
import 'notepage.dart';

class NoteWithTodos {
  final Note note;
  List<Todo> todos;

  NoteWithTodos({required this.note, required this.todos});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  List<NoteWithTodos> _items = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await DatabaseHelper.getNotes();
    final items = <NoteWithTodos>[];
    for (final note in notes) {
      final todos =
          note.id != null ? await DatabaseHelper.getTodos(note.id!) : <Todo>[];
      items.add(NoteWithTodos(note: note, todos: todos));
    }

    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  Future<void> _createNote() async {
    final title = await showDialog<String>(
      context: context,
      builder: (context) => _NewNoteDialog(),
    );
    if (title != null && title.trim().isNotEmpty) {
      final note = Note(id: null, title: title.trim());
      final insertedId = await DatabaseHelper.insertNote(note);
      setState(() {
        _items.add(NoteWithTodos(
            note: Note(id: insertedId, title: note.title), todos: []));
      });
    }
  }

  Future<void> _openNote(NoteWithTodos item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotePage(note: item.note),
      ),
    );
    await _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return GestureDetector(
                    onTap: () => _openNote(item),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.note.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(child: _buildPreview(item.todos)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPreview(List<Todo> todos) {
    if (todos.isEmpty) {
      return const Text('No todos', style: TextStyle(color: Colors.grey));
    }

    final preview = todos.take(3).toList();
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: preview
          .map((todo) => Text(
                '• ${todo.name}',
                overflow: TextOverflow.ellipsis,
              ))
          .toList(),
    );
  }
}

class _NewNoteDialog extends StatefulWidget {
  @override
  State<_NewNoteDialog> createState() => _NewNoteDialogState();
}

class _NewNoteDialogState extends State<_NewNoteDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New note'),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Title'),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_ctrl.text),
          child: const Text('Create'),
        ),
      ],
    );
  }
}
