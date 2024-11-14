import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _specialtyController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = true;

  Future<void> _getUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final username = userProvider.user?.username;

    if (username != null) {
      try {
        final response = await http.get(
          Uri.parse('http://localhost:8080/user/username?username=$username'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _usernameController.text = data['username'];
            _emailController.text = data['email'];
            _fullNameController.text = data['fullName'];
            _nationalityController.text = data['nationality'];
            _sexController.text = data['sex'];
            _phoneNumberController.text = data['phoneNumber'];
            _addressController.text = data['address'];
            _specialtyController.text = data['specialty'];
            _ageController.text = data['age'].toString();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load user data')),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _updateUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id;

    if (userId != null) {
      final updatedUser = {
        'id': userId,
        'username': _usernameController.text,
        'email': _emailController.text,
        'fullName': _fullNameController.text,
        'nationality': _nationalityController.text,
        'sex': _sexController.text,
        'phoneNumber': _phoneNumberController.text,
        'address': _addressController.text,
        'specialty': _specialtyController.text,
        'age': int.tryParse(_ageController.text),
        if (_newPasswordController.text.isNotEmpty &&
            _newPasswordController.text == _confirmPasswordController.text)
          'password': _newPasswordController.text,
      };

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/user/update'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updatedUser),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update user')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID is missing')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData(); // Fetch the user data when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C4151), // Set the AppBar background color to match Home Page
        automaticallyImplyLeading: true, // Keep back arrow for navigation
        elevation: 0, // Removes shadow to create a seamless look with the background
        title: Image.asset(
          'assets/images/image7.png', // Replace the "Profile" text with the image
          height: 40, // Set an appropriate height for the image
          fit: BoxFit.contain,
        ),
        centerTitle: true, // Center the image in the AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
      ),
      backgroundColor: Color(0xFF3C4151), // Set Scaffold background color to match Home Page
      body: Container(
        color: Color(0xFF3C4151), // Set background color to match the Home Page
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField('Username', _usernameController),
                        _buildTextField('Email', _emailController),
                        _buildTextField('Full Name', _fullNameController),
                        _buildTextField('Nationality', _nationalityController),
                        _buildTextField('Sex', _sexController),
                        _buildTextField('Phone Number', _phoneNumberController),
                        _buildTextField('Address', _addressController),
                        _buildTextField('Specialty', _specialtyController),
                        _buildTextField('Age', _ageController,
                            keyboardType: TextInputType.number),
                        _buildTextField('New Password', _newPasswordController,
                            obscureText: true),
                        _buildTextField('Confirm Password', _confirmPasswordController,
                            obscureText: true),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _updateUserData();
                              }
                            },
                            child: Text(
                              'Update Profile',
                              style: TextStyle(
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF42A5F4), // Match the button color to your theme
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
          // Skip validation if the field is empty (optional case)
          if (value == null || value.isEmpty) {
            return null;
          }

          // Specific validation for confirm password field
          if (label == 'Confirm Password' &&
              value != _newPasswordController.text) {
            return 'Passwords do not match';
          }

          // Return null when validation passes
          return null;
        },
      ),
    );
  }
}
