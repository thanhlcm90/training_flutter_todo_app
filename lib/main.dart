import 'package:flutter/material.dart';

import './models/models.dart';
import './widgets/todo_list_item.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // save data
  final List<ToDo> _todoList = <ToDo>[];
  final _checkedTodo = <ToDo>{};

  // text field
  final TextEditingController _textFieldController = TextEditingController();

  // add data to list
  void _addTodoItem(String name) {
    setState(() {
      _todoList.add(ToDo(name: name));
    });
    _textFieldController.clear();
  }

  void _editTodoItem(ToDo todo, String name) {
    setState(() {
      todo.name = name;
    });
    _textFieldController.clear();
  }

  void _handleCheckedChange(ToDo todo, bool isChecked) {
    setState(() {
      if (!isChecked) {
        _checkedTodo.add(todo);
      } else {
        _checkedTodo.remove(todo);
      }
    });
  }

  void _handleEditClick(BuildContext context, ToDo todo) {
    _displayEditDialog(context, todo);
  }

  void _handleRemoveClick(ToDo todo) {
    setState(() {
      _todoList.remove(todo);
    });
  }

  // display a dialog for the user to enter items
  Future _displayNewDialog(BuildContext context) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              // add button
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              // Cancel button
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // display a dialog for the user to enter items
  Future _displayEditDialog(BuildContext context, ToDo todo) async {
    _textFieldController.text = todo.name;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit task'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              // add button
              TextButton(
                child: const Text('SAVE'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _editTodoItem(todo, _textFieldController.text);
                },
              ),
              // Cancel button
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // iterates through our todo list titles.
  List<Widget> _getItems(BuildContext context) {
    return _todoList.map((ToDo todo) {
      return TodoListItem(
        todo: todo,
        isChecked: _checkedTodo.contains(todo),
        checkedChange: _handleCheckedChange,
        editClick: (todo) {
          _handleEditClick(context, todo);
        },
        removeClick: _handleRemoveClick,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Todo List'),
      ),
      body: ListView(children: _getItems(context)),
      // add items to the to-do list
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayNewDialog(context),
          tooltip: 'Add Item',
          child: const Icon(Icons.add)),
    );
  }
}
