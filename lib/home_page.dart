import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'friends_page.dart';
import 'subject.dart';
import 'subject_service.dart';
import 'subject_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Future<List<Subject>> subjects;
  final SubjectService subjectService = SubjectService();
  final TextEditingController _subjectController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    subjects = subjectService.fetchSubjects();
  }

  // Handles the bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 2:
        final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
        if (userId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendsPage(userId: userId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User ID is not available")),
          );
        }
        break;
      case 3:
        _logout(context);
        break;
    }
  }

  // Logout and navigate to the login page
  void _logout(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).clearUser();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Create a new subject and refresh the list
  void _createSubject(BuildContext context) async {
    if (_subjectController.text.isEmpty) return;

    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User is not logged in")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create a new subject
      await subjectService.createSubject(Subject(
        id: 0, // Backend generates the ID
        username: user.username,
        content: _subjectController.text,
        likeCount: 0,
        disLikeCount: 0,
        date: DateTime.now().toIso8601String(),
      ));
      // Refresh the subjects list
      setState(() {
        subjects = subjectService.fetchSubjects();
        _subjectController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create subject: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3C4151), // Set background color of AppBar to match the page
          automaticallyImplyLeading: false,
        ),
        body: Center(child: Text("No user data available")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3C4151), // Set background color of AppBar to match the page
        automaticallyImplyLeading: false,
        elevation: 0, // Removes the AppBar shadow for a seamless look
        title: ClipRRect(
          borderRadius: BorderRadius.circular(7), // Adds a border radius to match image styling
          child: Image.asset(
            'assets/images/image6.png', // Replace "Home" with the image at the top
            height: 40, // Adjust image height as needed
          ),
        ),
      ),
      body: Container(
        color: Color(0xFF3C4151), // Set the background color of the body to #3C4151
        child: Column(
          children: [
            // Create Subject Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _subjectController,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: "Comment as ${user.username}?",
                        hintStyle: TextStyle(
                          color: Color(0xFF71B8F5), // Set the hint text color to #71B8F5
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(color: Color(0xFF71B8F5)), // Set the input text color to #71B8F5
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _createSubject(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Color(0xFF3C4151), // Set the color to match comments post icon color hdlfkjdlkjflkdjflkdjflkdjflkdjfjdlkfjdlkjfldkjflkdjfkldjflkjdlfkjdlfjdlkjf
                      // shape: CircleBorder(), // Circular button
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.send, // Use send icon similar to comments post icon
                            color:Color(0xFF71B8F5),
                            
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Subject>>(
                future: subjects,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No subjects available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final subject = snapshot.data![index];
                        return SubjectCard(subject: subject);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Color(0xFF3C4151), // Set the background color to #3C4151 explicitly
        selectedItemColor: Color(0xFF71B8F5), // Set the color of the active icon to #71B8F5
        unselectedItemColor: Colors.white, // Set the color of the inactive icon to white
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // This ensures the color covers the entire bar area
      ),
    );
  }
}
