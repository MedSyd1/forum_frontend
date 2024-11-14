class Commentaire {
  final String commentaire;
  final String username;
  final int subjectId;
  final String date;

  Commentaire({
    required this.commentaire,
    required this.username,
    required this.subjectId,
    required this.date,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      commentaire: json['commentaire'],
      username: json['username'],
      subjectId: json['subjectId'],
      date: json['date'],
    );
  }
}
