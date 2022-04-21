import 'package:ideabarrel/misc/enums.dart';
import 'package:ideabarrel/models/comment.dart';

class Idea {
  String id;
  String title;
  String description;
  List<String> imgs;
  String submitterUID;
  int score;
  int totalLikes;
  int totalDislikes;
  List<Comment> comments;
  DateTime submittedAt;
  Department? department;
  bool approved;
  bool trending;

  Idea(
      {
      required this.id,
      required this.comments,
      required this.description,
      required this.imgs,
      required this.score,
      required this.totalLikes,
      required this.totalDislikes,
      required this.submittedAt,
      required this.submitterUID,
      required this.department,
      required this.title,
      required this.approved,
      required this.trending});
}
