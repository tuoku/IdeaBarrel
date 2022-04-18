class Comment {
  String id;
  String text;
  int commenterUID;
  DateTime submittedAt;
  int likes;

  Comment(
      {
      required this.id,
      required this.commenterUID,
      required this.likes,
      required this.submittedAt,
      required this.text});
}
