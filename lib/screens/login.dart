import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputField(context),
              _displayError(),
              _forgotPassword(),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header() {
    return Column(
      children: [
        Text(
          "Task List Application",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login"),
      ],
    );
  }

  _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 5),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(height: 5),
        ElevatedButton(
          onPressed: () {
            bool isValidCredentials = _validateCredentials(
              usernameController.text,
              passwordController.text,
            );

            if (isValidCredentials) {
              widget.onLoginSuccess();
            } else {
              setState(() {
                errorMessage = 'Invalid username or password';
              });
            }
          },
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 6),
            primary: Colors.blue, // Set the background color to blue
          ),
        )
      ],
    );
  }

  Widget _displayError() {
    if (errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.red),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  _forgotPassword() {
    return TextButton(onPressed: () {}, child: Text("Forgot password?"));
  }

  _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? "),
        TextButton(onPressed: () {}, child: Text("Sign Up"))
      ],
    );
  }

  bool _validateCredentials(String enteredUsername, String enteredPassword) {
    // Replace these hardcoded values with your actual predefined credentials
    String correctUsername = 'sameh';
    String correctPassword = '123456';

    bool isValid = enteredUsername == correctUsername &&
        enteredPassword == correctPassword;

    if (isValid) {
      // Navigate to the home page
      widget.onLoginSuccess();
    }

    return isValid;
  }
}
