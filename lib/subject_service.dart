import 'dart:convert';
import 'package:http/http.dart' as http;
import 'subject.dart';

class SubjectService {
  static const String baseUrl = 'http://localhost:8080/subject';

  // Fetch subjects and ensure they are ordered by id (newest first)
  Future<List<Subject>> fetchSubjects() async {
    final response = await http.get(Uri.parse('$baseUrl/subjects'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Subject> subjects = body.map((json) => Subject.fromJson(json)).toList();

      // Ensure subjects are sorted by id in descending order (newest to oldest)
      subjects.sort((a, b) => b.id.compareTo(a.id));

      return subjects;
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  // Create a new subject
  Future<void> createSubject(Subject subject) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': subject.username,
        'content': subject.content,
        'likeCount': subject.likeCount,
        'disLikeCount': subject.disLikeCount,
        'date': DateTime.now().toIso8601String(), // Ensure current time is used
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create subject');
    }
  }
}
