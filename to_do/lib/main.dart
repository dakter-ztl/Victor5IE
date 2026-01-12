import 'package:flutter/material.dart';

void main() {
  
  runApp(MyApp()); 
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(), 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(primarySwatch: Colors.purple), 
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

  class _HomeScreenState extends State<HomeScreen> {
  //inizializzo variabili

  // Lista to do
  List<String> todoList = [];

  // Controller per input
  final TextEditingController _controller = TextEditingController(); 

  // Index per vedere quale opzione nella lista verra modificata o cancellata
  int updateIndex = -1;
  

  //Metodi
  addList(String task){
    setState(() {
            todoList.add(task);
            _controller.clear();
      });
  }

   // Function to update an existing task
  updateListItem(String task, int index) {
    setState(() {
      todoList[index] = task;
      
      // Reset update index
      updateIndex = -1; 
      _controller.clear();
    });
  }

  // Function to delete a task
  deleteItem(index) {
    setState(() {
      todoList.removeAt(index);
    });
  }
@override

Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
        margin: EdgeInsets.all(10),
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
                        margin: EdgeInsets.only(left: 20),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 80,
                              child: Text(
                                  
                                // Display the task text
                                todoList[index], 
                                style: TextStyle(
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
                              icon: Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            
                            // Delete button
                            IconButton(
                              onPressed: () {
                                deleteItem(index);
                              },
                              icon: Icon(
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
                                borderSide: BorderSide(
                                  color: Colors.green,
                                )),
                            filled: true,
                            
                            // Placeholder text
                            labelText: 'Create Task....', 
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    
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
      ),
    );
  }
}