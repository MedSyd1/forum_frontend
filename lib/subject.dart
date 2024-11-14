class Subject {
  int id;
  String username;
  String content;
  int likeCount;  // Remove final to allow updating
  int disLikeCount;  // Remove final to allow updating
  String date;

  Subject({
    required this.id,
    required this.username,
    required this.content,
    required this.likeCount,
    required this.disLikeCount,
    required this.date,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      username: json['username'],
      content: json['content'],
      likeCount: json['likeCount'],
      disLikeCount: json['disLikeCount'],
      date: json['date'],
    );
  }
}
