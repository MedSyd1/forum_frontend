import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forum_frontend/home_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to capture input from TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorMessage;  // Variable to hold the error message

  Future<void> login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final Map<String, String> requestBody = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Successfully authenticated
        print("Login successful: ${response.body}");
        setState(() {
          errorMessage = null; // Clear error message on successful login
        });
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else if (response.statusCode == 404) {
        // User not found
        setState(() {
          errorMessage = "User not found";
        });
      } else if (response.statusCode == 401) {
        // Invalid credentials
        setState(() {
          errorMessage = "Invalid credentials";
        });
      } else {
        // Other errors
        setState(() {
          errorMessage = "Login failed with status: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error occurred: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Adds padding around the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centers the column vertically
          children: [
            // Username TextField
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(), // Adds a border around the TextField
              ),
            ),
            SizedBox(height: 20), // Adds vertical spacing between the fields

            // Password TextField
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(), // Adds a border around the TextField
              ),
              obscureText: true, // Hides the text input for passwords
            ),
            SizedBox(height: 20), // Adds vertical spacing before the button

            // Login Button
            ElevatedButton(
              onPressed: () {
                print("Username: ${_usernameController.text}");
                print("Password: ${_passwordController.text}");
                login();
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white, // Sets the text color to white
                  fontSize: 16, // Optional: Sets the font size
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Sets the background color to light blue
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Optional: Adjusts padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Optional: Rounds the button corners
                ),
              ),
            ),
            SizedBox(height: 20), // Adds vertical spacing before the error message

            // Error message (if any)
            if (errorMessage != null) 
              Text(
                errorMessage!,
                style: TextStyle(
                  color: Colors.red,  // Red color for error message
                  fontSize: 16,       // Optional: Set the font size
                  fontWeight: FontWeight.bold, // Optional: Make the text bold
                ),
              ),
          ],
        ),
      ),
    );
  }
}
