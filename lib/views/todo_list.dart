import 'package:flutter/material.dart';

import './todo_list_item.dart';
import '../models/models.dart';

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

  // edit data from list
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

  // display a dialog for the user to add new item
  Future _displayNewDialog(BuildContext context) async {
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

  // display a dialog for the user to edit the item
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView(children: _getItems(context)),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayNewDialog(context),
          tooltip: 'Add Item',
          child: const Icon(Icons.add)),
    );
  }
}
