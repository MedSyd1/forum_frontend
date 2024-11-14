import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();

  Future<void> registerUser() async {
    final String fullName = _fullNameController.text;
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final int age = int.tryParse(_ageController.text) ?? 0;
    final String nationality = _nationalityController.text;
    final String sex = _sexController.text;
    final String phoneNumber = _phoneNumberController.text;
    final String address = _addressController.text;
    final String specialty = _specialtyController.text;

    final Map<String, dynamic> requestBody = {
      'fullName': fullName,
      'username': username,
      'email': email,
      'password': password,
      'age': age,
      'nationality': nationality,
      'sex': sex,
      'phoneNumber': phoneNumber,
      'address': address,
      'specialty': specialty,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/user/addUser'), // Your backend URL
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successfully registered
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("User registered successfully!"),
        ));

        // Navigate to the login page after registration
        Navigator.pushReplacementNamed(context, '/login'); // Assuming you have '/login' route
      } else {
        // Error registering
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to register user: ${response.body}"),
        ));
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C4151), // Set the AppBar background color to match other pages
        elevation: 0, // Removes shadow for a seamless look with the background
        automaticallyImplyLeading: true, // Show back arrow
        iconTheme: IconThemeData(color: Colors.white), // Set the back arrow color to white
        title: Image.asset(
          'assets/images/image9.png', // Replace "Register" text with image9
          height: 40, // Set an appropriate height for the image
          fit: BoxFit.contain,
        ),
        centerTitle: true, // Center the image in the AppBar
      ),
      backgroundColor: Color(0xFF3C4151), // Set the background color to match other pages
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Full Name', _fullNameController),
              _buildTextField('Username', _usernameController),
              _buildTextField('Email', _emailController),
              _buildTextField('Password', _passwordController, obscureText: true),
              _buildTextField('Age', _ageController, keyboardType: TextInputType.number),
              _buildTextField('Nationality', _nationalityController),
              _buildTextField('Sex', _sexController),
              _buildTextField('Phone Number', _phoneNumberController),
              _buildTextField('Address', _addressController),
              _buildTextField('Specialty', _specialtyController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      registerUser();
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white, // Set the text color to white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF42A5F4), // Set the button color to match other pages
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Adjust padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounds the button corners
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white, // Set label color to white
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF71B8F5), width: 1.5), // Match to the Home Page hint color
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        ),
        style: TextStyle(
          color: Color(0xFF42A5F4), // Set the input text color to match the button color
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
