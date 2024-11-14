import 'package:flutter/material.dart';
import 'commentaire_service.dart';
import 'commentaire.dart';

class CommentairesDialog extends StatefulWidget {
  final int subjectId;

  const CommentairesDialog({required this.subjectId});

  @override
  _CommentairesDialogState createState() => _CommentairesDialogState();
}

class _CommentairesDialogState extends State<CommentairesDialog> {
  final TextEditingController _commentController = TextEditingController();
  late Future<List<Commentaire>> _comments;
  FocusNode _focusNode = FocusNode(); // Add FocusNode here

  @override
  void initState() {
    super.initState();
    _comments = CommentaireService().fetchComments(widget.subjectId);
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the FocusNode when done
    super.dispose();
  }

  // Handle posting a new comment
  void _postComment() async {
    final commentaireText = _commentController.text;
    if (commentaireText.isEmpty) return;

    // Call backend API to add comment
    await CommentaireService().addComment(
      Commentaire(
        commentaire: commentaireText,
        username: "User", // Replace with the current logged-in user
        subjectId: widget.subjectId,
        date: DateTime.now().toIso8601String(),
      ),
    );

    // Refresh the list of comments
    setState(() {
      _comments = CommentaireService().fetchComments(widget.subjectId);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Commentaires'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display the list of comments
          FutureBuilder<List<Commentaire>>(
            future: _comments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No comments yet');
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final commentaire = snapshot.data![index];
                    return ListTile(
                      title: Text(commentaire.username),
                      subtitle: Text(commentaire.commentaire),
                      trailing: Text(commentaire.date),
                    );
                  },
                );
              }
            },
          ),
          // Input field to add new comment
          TextField(
            controller: _commentController,
            focusNode: _focusNode, // Explicitly manage focus
            autofocus: false,  // Prevent auto-focus on text field
            decoration: InputDecoration(
              hintText: 'Write a comment...',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _postComment,
          child: Text('Post'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
