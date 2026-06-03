import 'package:flutter/material.dart';
import 'helper.dart';
import 'model.dart';
import 'widgets.dart';

void main() => runApp(const MaterialApp(
  title: 'zKeep',
  debugShowCheckedModeBanner: false,
  home: NotesPage(),
));

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  void refreshNotes() async {
    try {
      final fetchedNotes = await DatabaseHelper.getNotes();
      setState(() {
        notes = fetchedNotes;
      });
    } catch (e) {
      _showError("Errore nel caricamento delle note: $e");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void showAddNoteDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nuova nota"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(hintText: "Titolo")),
            TextField(controller: descController, decoration: const InputDecoration(hintText: "Breve descrizione")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annulla")),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                try {
                  await DatabaseHelper.insertNote(Note(
                    id: null, 
                    title: titleController.text,
                    description: descController.text,
                  ));
                  refreshNotes();
                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  _showError("Errore nel salvataggio: $e");
                }
              }
            },
            child: const Text("Crea"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Le mie note")),
      body: notes.isEmpty
          ? const Center(child: Text("Nessuna nota presente"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) => NoteCard(
                note: notes[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TodoPage(note: notes[index])),
                ).then((_) => refreshNotes()),
                onDelete: () async {
                  try {
                    await DatabaseHelper.deleteNote(notes[index]);
                    refreshNotes();
                  } catch (e) {
                    _showError("Errore nell'eliminazione: $e");
                  }
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoPage extends StatefulWidget {
  final Note note;
  const TodoPage({super.key, required this.note});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> todoList = [];
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshTodoList();
  }

  void refreshTodoList() async {
    try {
      final todos = await DatabaseHelper.getTodos(widget.note.id!);
      setState(() {
        todoList = todos;
      });
    } catch (e) {
      _showError("Errore nel caricamento dei todo: $e");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void showTodoDialog({Todo? todo}) {
    textEditingController.text = todo?.name ?? "";
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(todo == null ? "Nuovo promemoria" : "Modifica promemoria"),
        content: TextField(controller: textEditingController),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annulla")),
          TextButton(
            onPressed: () async {
              try {
                if (todo == null) {
                  await DatabaseHelper.insertTodo(Todo(id: null, noteId: widget.note.id!, name: textEditingController.text));
                } else {
                  await DatabaseHelper.updateTodo(Todo(
                    id: todo.id,
                    noteId: todo.noteId,
                    name: textEditingController.text,
                    checked: todo.checked,
                  ));
                }
                refreshTodoList();
                if (mounted) Navigator.pop(context);
              } catch (e) {
                _showError("Errore nel salvataggio: $e");
              }
            }, 
            child: const Text("Salva")
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note.title)),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (_, index) => TodoItem(
          todo: todoList[index],
          onTodoChanged: (t) async { 
            try {
              t.checked = !t.checked; 
              await DatabaseHelper.updateTodo(t);
              refreshTodoList(); 
            } catch (e) {
              _showError("Errore nell'aggiornamento: $e");
            }
          },
          onTodoDelete: (t) async {
            try {
              await DatabaseHelper.deleteTodo(t);
              refreshTodoList();
            } catch (e) {
              _showError("Errore nell'eliminazione: $e");
            }
          },
          onTodoEdit: (t) => showTodoDialog(todo: t),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTodoDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}