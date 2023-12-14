import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';
import '../services/api_service.dart';
import '../screens/login.dart';
import '../screens/add_todo_page.dart'; // Import AddTodoPage

class Home extends StatefulWidget {
  final ApiService apiService;

  Home({Key? key, required this.apiService}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Todo>> _todos;

  @override
  void initState() {
    _todos = widget.apiService.fetchTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder<List<Todo>>(
        future: _todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Todo> todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                return ToDoItem(
                  todo: todo,
                  onToDoChanged: (todo) {
                    _handleToDoChange(todo);
                  },
                  onDeleteItem: (id) {
                    _deleteToDoItem(id);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTodoPage(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, // Set the background color to blue
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/Picture1.jpg'),
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Task List For Sameh',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleToDoChange(Todo todo) async {
    try {
      print('Updating todo: $todo');
      await widget.apiService.updateTodo(todo);
      print('Todo updated successfully.');
      // Refresh the todo list after updating
      setState(() {
        _todos = widget.apiService.fetchTodos();
      });
    } catch (error) {
      print('Error updating todo: $error');
    }
  }

  Future<void> _deleteToDoItem(String id) async {
    if (id.isNotEmpty) {
      try {
        print('Deleting todo with ID: $id');
        await widget.apiService.deleteTodo(id);
        print('Todo deleted successfully.');
        // Refresh the todo list after deletion
        setState(() {
          _todos = widget.apiService.fetchTodos();
        });
      } catch (error) {
        print('Error deleting todo: $error');
      }
    }
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(
          onLoginSuccess: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
    );
  }

  void _navigateToAddTodoPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTodoPage(apiService: widget.apiService),
      ),
    );
  }
}