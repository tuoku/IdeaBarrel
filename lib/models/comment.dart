class Comment {
  String text;
  int commenterUID;
  DateTime submittedAt;
  int likes;

  Comment(
      {required this.commenterUID,
      required this.likes,
      required this.submittedAt,
      required this.text});
}
