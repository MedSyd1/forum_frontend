import 'package:flutter/material.dart';
import 'package:forum_frontend/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FriendsPage extends StatefulWidget {
  final int? userId; // User ID passed from the HomePage

  // Constructor to accept userId as int?
  FriendsPage({required this.userId});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<User> _users = []; // List to hold users fetched from the backend
  bool _isLoading = true; // Flag to show loading indicator

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users when the page is loaded
  }

  // Fetch users from the backend
  Future<void> _fetchUsers() async {
    final url = 'http://localhost:8080/user/all/${widget.userId}'; // Replace with your backend URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _users = data.map((user) => User.fromJson(user)).toList();
          _isLoading = false; // Stop loading when data is fetched
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading even in case of error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C4151), // Set AppBar background to match Home Page
        elevation: 0, // Removes shadow for a seamless look
        automaticallyImplyLeading: true, // Back arrow for navigation
        iconTheme: IconThemeData(
          color: Colors.white, // Make back arrow white
        ),
        title: Image.asset(
          'assets/images/image8.png', // Replace the "Friends" text with the image
          height: 40, // Set an appropriate height for the image
          fit: BoxFit.contain,
        ),
        centerTitle: true, // Center the image in the AppBar
      ),
      backgroundColor: Color(0xFF3C4151), // Set background color to match Home Page
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _users.isEmpty
              ? Center(
                  child: Text(
                    'No friends available',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                )
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(10), // Space between the containers
                      padding: EdgeInsets.all(15), // Padding inside the container
                      decoration: BoxDecoration(
                        color: Color(0xFF4A4E69), // Background color similar to comments section
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color.fromARGB(255, 147, 202, 247), // Set a white background
                            child: Icon(
                              Icons.person,
                              color: const Color.fromARGB(255, 95, 95, 95), // Placeholder color
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _users[index].username, // Display username
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Set username color to white
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.work, size: 20, color: Color(0xFF82C480)), // Job icon
                                  SizedBox(width: 5),
                                  Text(
                                    _users[index].specialty, // Display specialty
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white, // Set specialty text color to white
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.email, size: 20, color: Color(0xFFF08570)), // Email icon
                                  SizedBox(width: 5),
                                  Text(
                                    _users[index].email, // Display email
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white, // Set email text color to white
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
