import 'package:ideabarrel/misc/enums.dart';
import 'package:ideabarrel/models/comment.dart';

class Idea {
  String id;
  String title;
  String description;
  List<String> imgs;
  int submitterUID;
  int score;
  List<Comment> comments;
  DateTime submittedAt;
  Department? department;

  Idea(
      {
      required this.id,
      required this.comments,
      required this.description,
      required this.imgs,
      required this.score,
      required this.submittedAt,
      required this.submitterUID,
      required this.department,
      required this.title});
}
