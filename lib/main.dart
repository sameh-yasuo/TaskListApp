import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/home.dart';
import './screens/login.dart';
import 'services/api_service.dart';

void main() {
  final ApiService apiService =
      ApiService(apiUrl: 'https://jsonplaceholder.typicode.com/todos');

  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  const MyApp({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
          // Your theme settings
          ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => Home(apiService: apiService),
        '/login': (context) => LoginPage(onLoginSuccess: () {
              // Handle login success logic here
              Navigator.pushReplacementNamed(context, '/home');
            }),
      },
    );
  }
}
