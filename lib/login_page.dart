import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


class LoginPage extends StatelessWidget {
  // Controllers to capture input from TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async{
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final Map<String,String> requestBody = {
      'username' : username,
      'password' : password,
     };

  try {

        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/auth/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username, "password": password}),
);

      // Check the response status
      if (response.statusCode == 200) {
        // Successfully authenticated
        print("Login successful: ${response.body}");
      } else if (response.statusCode == 404) {
        // User not found
        print("User not found");
      } else if (response.statusCode == 401) {
        // Invalid credentials
        print("Invalid credentials");
      } else {
        // Other errors
        print("Login failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
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
          ],
        ),
      ),
    );
  }
}
