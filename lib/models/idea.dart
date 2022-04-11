import 'package:ideabarrel/models/comment.dart';

class Idea {
  String title;
  String description;
  List<String> imgs;
  int submitterUID;
  int score;
  List<Comment> comments;
  DateTime submittedAt;

  Idea(
      {required this.comments,
      required this.description,
      required this.imgs,
      required this.score,
      required this.submittedAt,
      required this.submitterUID,
      required this.title});
}
