import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../services/api_service.dart';

class AddTodoPage extends StatefulWidget {
  final ApiService apiService;

  AddTodoPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Todo Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addTodo();
              },
              child: Text('Add Todo'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo() async {
    String title = _titleController.text.trim();
    if (title.isNotEmpty) {
      try {
        Todo newTodo = Todo(title: title);
        await widget.apiService.addTodo(newTodo);

        // Show a snackbar to indicate successful addition
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New task added successfully'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to the home page after adding the todo
        Navigator.pop(context);
      } catch (error) {
        print('Error adding todo: $error');
        // Handle error, show a snackbar, etc.
      }
    }
  }
}
