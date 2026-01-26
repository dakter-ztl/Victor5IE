import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifier.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zkeep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider<NoteListNotifier>(
        create: (notifier) => NoteListNotifier(),
        child: const MyHomePage(title: 'zKeep'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final NoteListNotifier notifier = context.watch<NoteListNotifier>();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: notifier.length,
        itemBuilder: (context, index) {
          return NoteCard(note: notifier.getNote(index));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => notifier.addNote(),
        tooltip: 'Crea Nota',
        child: const Icon(Icons.add),
      ),
    );
  }
}
