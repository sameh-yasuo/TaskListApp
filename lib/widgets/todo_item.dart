import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onToDoChanged;
  final Function(int) onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);
  void _toggleCompleted() {
    Todo updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      completed: !(todo.completed ?? false),
    );
    onToDoChanged(updatedTodo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          _toggleCompleted();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            todo.completed ?? false
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: tdBlue,
          ),
          onPressed: _toggleCompleted,
        ),
        title: Text(
          todo.title!,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: todo.completed! ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: tdRed,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              // Pass todo.id, which might be null, to onDeleteItem
              onDeleteItem(todo.id!);
            },
          ),
        ),
      ),
    );
  }
}
