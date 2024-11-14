import 'dart:convert';
import 'package:http/http.dart' as http;
import 'commentaire.dart';

class CommentaireService {
  static const String baseUrl = 'http://localhost:8080/commentaire';

  // Fetch all comments for a subject
  Future<List<Commentaire>> fetchComments(int subjectId) async {
    final response = await http.get(Uri.parse('$baseUrl/all/$subjectId'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => Commentaire.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }


 // Add like/dislike to the subject
  Future<void> updateLikeDislike(int subjectId, String action) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$subjectId/$action'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update like/dislike');
    }
  }

  // Add a new comment
  Future<void> addComment(Commentaire commentaire) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'commentaire': commentaire.commentaire,
        'username': commentaire.username,
        'subjectId': commentaire.subjectId,
        'date': commentaire.date,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }
}
