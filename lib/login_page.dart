import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forum_frontend/home_page.dart';
import 'package:forum_frontend/user.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'user_provider.dart'; // Import the UserProvider
import 'register_page.dart'; // Import the RegisterPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to capture input from TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? errorMessage; // Variable to hold the error message

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
        body: jsonEncode(requestBody),
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Successfully authenticated
        print("Login successful: ${response.body}");
        setState(() {
          errorMessage = null; // Clear error message on successful login
        });

        final userDTO = jsonDecode(response.body);
        final user = User.fromJson(userDTO);

        // Store the user in the provider
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        // Navigate to the HomePage
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
        backgroundColor: Color(0xFF3C4151), // Set the AppBar background color to match the page
        elevation: 0, // Removes the AppBar shadow for a seamless look
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body: Container(
        color: Color(0xFF3C4151), // Set background color to #3C4151
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0), // Adds padding around the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align elements to the top of the screen
            children: [
              SizedBox(height: 50), // Adds vertical spacing from the top of the screen

              // Larger Logo Image at the Top with Border Radius
              ClipRRect(
                borderRadius: BorderRadius.circular(7), // Border radius of 7px
                child: Image.asset(
                  'assets/images/image6.png', // Use image6.png as the logo
                  height: 180, // Make the logo larger
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 40), // Adds vertical spacing between the image and input fields

              // Username TextField
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white), // White label text
                  filled: false, // Transparent background
                ),
                style: TextStyle(color: Colors.white), // White text color
              ),
              SizedBox(height: 20), // Adds vertical spacing between the fields

              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white), // White label text
                  filled: false, // Transparent background
                ),
                style: TextStyle(color: Colors.white), // White text color
                obscureText: true, // Hides the text input for passwords
              ),
              SizedBox(height: 20), // Adds vertical spacing before the button

              // Login Button without Icon and with New Color
              ElevatedButton(
                onPressed: () {
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
                  backgroundColor: Color(0xFF42A5F4), // Set the button color to #42A5F4
                  elevation: 5, // Adds a slight elevation for 3D effect
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15), // Optional: Adjusts padding
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
                    color: Colors.red, // Red color for error message
                    fontSize: 16, // Optional: Set the font size
                    fontWeight: FontWeight.bold, // Optional: Make the text bold
                  ),
                ),

              // Link to Register Page with padding at the bottom
              SizedBox(height: 40), // Adds vertical spacing before the link
              TextButton(
                onPressed: () {
                  // Navigate to the RegisterPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "Don't have an account? Register here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 2,
                      height: 1.5,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
