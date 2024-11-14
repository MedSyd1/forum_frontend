import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subject.dart';
import 'commentaire.dart';
import 'commentaire_service.dart';
import 'user_provider.dart'; // To access the current user

class SubjectCard extends StatefulWidget {
  final Subject subject;

  const SubjectCard({required this.subject});

  @override
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  final TextEditingController _commentController = TextEditingController();
  late Future<List<Commentaire>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = CommentaireService().fetchComments(widget.subject.id);  // Fetch comments for the specific subject
  }

  // Handle posting a new comment
  void _postComment() async {
    final commentaireText = _commentController.text;
    if (commentaireText.isEmpty) return;

    final currentUser = Provider.of<UserProvider>(context, listen: false).user;

    // Ensure the current user is not null
    if (currentUser == null) {
      // Handle error, if needed (e.g., show a message or handle no user case)
      return;
    }

    // Call backend API to add the comment
    await CommentaireService().addComment(
      Commentaire(
        commentaire: commentaireText,
        username: currentUser.username, // Dynamically fetch the current user's username
        subjectId: widget.subject.id,
        date: DateTime.now().toIso8601String(),
      ),
    );

    // Refresh the list of comments
    setState(() {
      _comments = CommentaireService().fetchComments(widget.subject.id);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    // Check if the subject is created by the current user
    bool isSubjectByCurrentUser = widget.subject.username == currentUser?.username;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Color(0xFF2E3440),  // Dark gray background similar to Facebook Dark Mode
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Details with no background color
            Padding(
              padding: const EdgeInsets.all(8.0), // Add some padding around the content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with user icon and username
                  Row(
                    children: [
                      Icon(Icons.account_circle, size: 20, color: Colors.white), // User icon
                      SizedBox(width: 8),
                      Text(
                        widget.subject.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isSubjectByCurrentUser ? Color(0xFF82C480) : Colors.white, // Color the current user's username with #82C480
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Subject content with no gray background
                  Text(
                    widget.subject.content,
                    style: TextStyle(fontSize: 14, color: Colors.white), // White text color for the content
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.subject.date,
                    style: TextStyle(fontSize: 12, color: Colors.grey), // Lighter grey text for date
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            // Comment Section Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Comments',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16, 
                  color: Color(0xFF75BEFF), // Set color of "Comments" text to #75BEFF
                ),
              ),
            ),
            // FutureBuilder to display comments
            FutureBuilder<List<Commentaire>>(
              future: _comments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No comments yet', style: TextStyle(color: Colors.white));
                } else {
                  return Column(
                    children: snapshot.data!.map((commentaire) {
                      // Check if the comment is by the current user
                      bool isCommentByCurrentUser = commentaire.username == currentUser?.username;

                      return Container(
                        margin: EdgeInsets.only(bottom: 8), // Add margin between comments
                        decoration: BoxDecoration(
                          color: isCommentByCurrentUser
                              ? Color(0xFF3B4252) // Neutral gray color for the current user's comment
                              : Color(0xFF3B4252), // Neutral gray for other comments as well
                          borderRadius: BorderRadius.circular(7), // Border radius of 7px for the comment container
                        ),
                        child: ListTile(
                          // Row with user icon and comment username
                          leading: Icon(Icons.account_circle, size: 20, color: Colors.white), // User icon for comment
                          title: Text(
                            commentaire.username,
                            style: TextStyle(
                              color: isCommentByCurrentUser ? Color(0xFF82C480) : Colors.white, // Current user's comment username color
                            ),
                          ), // White text for username
                          subtitle: Text(commentaire.commentaire, style: TextStyle(color: Colors.white70)), // Lighter text for the comment content
                          trailing: Text(commentaire.date, style: TextStyle(color: Colors.grey)), // Lighter grey text for the comment date
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            // Text field to add new comment
            TextField(
              controller: _commentController,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                hintStyle: TextStyle(color: Colors.white70), // Lighter text for hint
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF75BEFF)), // Set post arrow color to #75BEFF
                  onPressed: _postComment,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70), // White underline
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // White underline when focused
                ),
              ),
              style: TextStyle(color: Colors.white), // White text color for the input field
            ),
          ],
        ),
      ),
    );
  }
}
