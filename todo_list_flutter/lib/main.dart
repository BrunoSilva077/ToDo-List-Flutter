import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Todo List Application'),
      ),
    );
  }
}



class MyAppState extends ChangeNotifier{
  List<TodoItem> todos = [];
  void addTodo(String todo){
    todos.add(
      TodoItem(
        text: todo,
        isCompleted: false,
      )
    );
    notifyListeners();
  }

  void removeTodo(int index){
    todos.removeAt(index);
    notifyListeners();
  }

  void toggleTodoCompleted(int index) {
    todos[index].isCompleted = !todos[index].isCompleted;
    notifyListeners();
  }

  void editTodoText(int index, String newText){
    todos[index].text = newText;
    notifyListeners();
  }

}

class TodoItem {
  String text;
  bool isCompleted;

  TodoItem({required this.text, required this.isCompleted});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _todoController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var todos = appState.todos;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        labelText: 'Enter your task',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value){
                          String newTodo = _todoController.text;
                          if(newTodo.isNotEmpty && !newTodo.contains(RegExp(r'^\s+$'))){
                            setState(() {
                              appState.addTodo(_todoController.text);
                              _todoController.clear();
                            });
                          }
                        },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    iconSize: 40.0,
                    onPressed: (){
                      String newTodo = _todoController.text;
                      if(newTodo.isNotEmpty && !newTodo.contains(RegExp(r'^\s+$'))){
                        setState(() {
                          appState.addTodo(_todoController.text);
                          _todoController.clear();
                        });
                      }
                    },
                  ),
                ],
                ),
            ),
              Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(todos[index].text),
                      leading: Checkbox(
                        value: todos[index].isCompleted,
                        onChanged: (value) {
                          setState(() {
                            appState.toggleTodoCompleted(index);
                          });
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Edit Todo'),
                                    content: TextField(
                                      controller: TextEditingController(text: todos[index].text),
                                      onChanged: (value) {
                                        todos[index].text = value;
                                      },
                                      onSubmitted: (value) {
                                        appState.editTodoText(index, value);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            appState.editTodoText(index, todos[index].text);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text('Save'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                appState.removeTodo(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ],
            )
      ),
    );
  }
}