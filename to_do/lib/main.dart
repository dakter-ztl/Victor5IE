import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notifier.dart';
import 'widgets.dart';

void main() {
<<<<<<< HEAD
  runApp(const MyApp());
=======
  
  runApp(const MyApp()); 
>>>>>>> 07d8eefdc8a217ce408670ca776e65e77681aacb
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'todo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
      home: ChangeNotifierProvider<TodoListNotifier>(
        create: (_) => TodoListNotifier(),
        child: const MyHomePage(title: 'todo'),
      ),
=======
      home: const HomeScreen(), 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(primarySwatch: Colors.purple), 
>>>>>>> 07d8eefdc8a217ce408670ca776e65e77681aacb
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final TodoListNotifier notifier = context.watch<TodoListNotifier>();
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        shadowColor: Theme.of(context).shadowColor,
        elevation: 4,
        title: Text(title),
      ),
      body: notifier.length == 0
          ? const Center(child: Text('nessun todo'))
          : const NoteCard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => notifier.addTodo(),
        tooltip: 'add todo',
        child: const Icon(Icons.add),
=======
        title: const Text(
          "Todo Application",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        
        // Centers the app bar title
        centerTitle: true, 
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 90,
              child: ListView.builder(
                  
                  // Number of tasks in the list
                  itemCount: todoList.length, 
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      
                      // Card background color
                      color: Colors.green, 
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 80,
                              child: Text(
                                  
                                // Display the task text
                                todoList[index], 
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            
                            // Edit button
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.clear();
                                  _controller.text = todoList[index];
                                  updateIndex = index;
                                });
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            
                            // Delete button
                            IconButton(
                              onPressed: () {
                                deleteItem(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 70,
                      child: SizedBox(
                        height: 60,
                        child: TextFormField(
                            
                          // Input field controller
                          controller: _controller, 
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                )),
                            filled: true,
                            
                            // Placeholder text
                            labelText: 'Create Task....', 
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    
                    // Floating action button for adding/updating tasks
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      onPressed: () {
                        updateIndex != -1
                            ? updateListItem(_controller.text,
                                updateIndex) // Update task if editing
                            : addList(_controller.text); // Add new task
                      },
                      child: Icon(updateIndex != -1
                          ? Icons.edit
                          : Icons.add), // Icon changes based on action
                    ),
                  ],
                )),
          ],
        ),
>>>>>>> 07d8eefdc8a217ce408670ca776e65e77681aacb
      ),
    );
  }
}