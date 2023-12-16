import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';
import '../services/api_service.dart';
import '../screens/login.dart';
import '../screens/add_todo_page.dart';

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
    _fetchTodos(); // Fetch todos when the widget is initialized
    super.initState();
  }

  Future<void> _fetchTodos() async {
    try {
      setState(() {
        _todos = widget.apiService.fetchTodos();
      });
    } catch (error) {
      print('Error fetching todos: $error');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch todos. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
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
          } else if (snapshot.data == null ||
              (snapshot.data as List<Todo>).isEmpty) {
            return Text('No todos available.');
          } else {
            List<Todo> todos = snapshot.data as List<Todo>;
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
          _navigateToAddTodoPage(context); // Navigate to AddTodoPage
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, // Set the background color
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

  Future<void> _handleToDoChange(Todo updatedTodo) async {
    try {
      print('Updating todo: $updatedTodo');
      await widget.apiService.updateTodo(updatedTodo);
      print('Todo updated successfully.');

      // Fetch updated todos after updating
      _fetchTodos();
    } catch (error) {
      print('Error updating todo: $error');
      // Display an error message to the user, similar to the fetching error.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update todo. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _deleteToDoItem(int id) async {
    if (id != 0) {
      try {
        print('Deleting todo with ID: $id');
        await widget.apiService.deleteTodo(id);
        print('Todo deleted successfully.');
        //refrelching the list after delete an item**************
        List<Todo> todos = await _todos;
        setState(() {
          _todos = Future.value(todos.where((todo) => todo.id != id).toList());
        });

        // Show a snackbar to indicate successful deletion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Todo deleted successfully'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green),
        );
      } catch (error) {
        print('Error deleting todo: $error');
        // Display an error message to the user, similar to the fetching error.
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete todo. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
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
