import 'package:flutter/material.dart';
import 'databaseHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zkeep SQL',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // lista che contiene i dati dal db
  List<Map<String, dynamic>> journalList = [];
  bool isLoading = true;

  // controller per i campi di testo
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // funzione per caricare i dati
  void refreshJournals() async {
    final data = await DatabaseHelper.instance.getItems();
    setState(() {
      journalList = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshJournals();
  }

  // mostra il form per aggiungere note
  void showForm(int? id) async {
    titleController.text = '';
    contentController.text = '';

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Titolo'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(hintText: 'Descrizione'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await addItem();
                if (mounted) {
                   Navigator.of(context).pop();
                }
              },
              child: const Text('Salva Nota'),
            )
          ],
        ),
      ),
    );
  }

  // aggiunge elemento al db
  Future<void> addItem() async {
    await DatabaseHelper.instance.createItem(
      titleController.text,
      contentController.text,
    );
    refreshJournals();
  }

  // elimina elemento dal db
  void deleteItem(int id) async {
    await DatabaseHelper.instance.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nota eliminata!')),
    );
    refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZKeep Note')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: journalList.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(journalList[index]['title']),
                  subtitle: Text(journalList[index]['content']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteItem(journalList[index]['id']),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showForm(null),
      ),
    );
  }
}