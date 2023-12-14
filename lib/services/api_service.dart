// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/todo.dart';

class ApiService {
  final String apiUrl;

  ApiService({required this.apiUrl});

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> todosJson = json.decode(response.body);
      List<Todo> todos = todosJson.map((json) => Todo.fromJson(json)).toList();
      return todos;
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add todo: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding todo: $error');
      throw Exception('Failed to add todo');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${todo.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update todo: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating todo: $error');
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      print('Deleting todo with ID: $id');
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo: ${response.statusCode}');
      }

      print('Todo deleted successfully.');
    } catch (error) {
      print('Error deleting todo: $error');
      throw Exception('Failed to delete todo');
    }
  }
}
