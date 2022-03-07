import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/models.dart';

typedef TodoCheckedChange = Function(ToDo todo, bool checked);
typedef TodoEditClick = Function(ToDo todo);
typedef TodoRemoveClick = Function(ToDo todo);

class TodoListItem extends StatelessWidget {
  TodoListItem(
      {required this.todo,
      required this.isChecked,
      required this.checkedChange,
      required this.editClick,
      required this.removeClick})
      : super(key: ObjectKey(todo));

  final ToDo todo;
  final bool isChecked;
  final TodoCheckedChange checkedChange;
  final TodoEditClick editClick;
  final TodoRemoveClick removeClick;

  TextStyle? _getTextStyle(BuildContext context) {
    if (!isChecked) return null;

    return const TextStyle(
        color: Colors.black54, decoration: TextDecoration.lineThrough);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            // An action can be bigger than the others.
            onPressed: (context) {
              removeClick(todo);
            },
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.clear,
            label: 'Remove',
          ),
          SlidableAction(
            onPressed: (context) {
              editClick(todo);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ]),
        child: ListTile(
          title: Text(todo.name, style: _getTextStyle(context)),
          leading: Checkbox(
              value: isChecked,
              onChanged: (value) {
                checkedChange(todo, isChecked);
              }),
          onTap: () {
            checkedChange(todo, isChecked);
          },
        ));
  }
}
