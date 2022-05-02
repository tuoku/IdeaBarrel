import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ideabarrel/misc/enums.dart';
import 'package:ideabarrel/models/comment.dart';

import '../models/cosmos.dart';
import '../models/idea.dart';
import '../models/user.dart';

class CosmosRepo {
  // --- singleton boilerplate
  static final CosmosRepo _cosmosRepo = CosmosRepo._internal();
  factory CosmosRepo() {
    return _cosmosRepo;
  }
  CosmosRepo._internal();
  // ---

  Cosmos cosmos = Cosmos(documentDBMasterKey: dotenv.env['COSMOS_KEY']!);

  Future<List<Idea>> getAllIdeas() async {
    Map<String, dynamic> res = await cosmos.queryCosmos(
        isQuery: true,
        url:
            'https://ideabarrel.documents.azure.com:443/dbs/Ideas/colls/Ideas/docs',
        method: 'GET');
    List<dynamic> maps = res["Documents"];
    return List.generate(maps.length, (i) {
      return Idea(
          id: maps[i]['id'],
          title: maps[i]['title'],
          description: maps[i]['description'],
          submittedAt:
              DateTime.fromMillisecondsSinceEpoch(maps[i]['submittedAt'] ?? 0),
          score: maps[i]['score'],
          totalDislikes: maps[i]['totalDislikes'],
          totalLikes: maps[i]['totalLikes'],
          comments: List.generate(maps[i]['comments'].length, (ii) {
            return Comment(
                id: maps[i]['comments'][ii]['id'],
                commenterUID: maps[i]['comments'][ii]['commenterUID'],
                likes: maps[i]['comments'][ii]['likes'],
                submittedAt: DateTime.fromMillisecondsSinceEpoch(
                    maps[i]['comments'][ii]['submittedAt']),
                text: maps[i]['comments'][ii]['text']);
          }),
          imgs: List.generate(maps[i]['imgs'].length, (iii) {
            return maps[i]['imgs'][iii].toString();
          }),
          department: Department.values
              .firstWhere((e) => e.toString() == maps[i]['department']),
          submitterUID: maps[i]['submitterUID'],
          approved: maps[i]['approved'],
          trending: maps[i]['trending']);
    });
  }

  Future<List<User>> getAllUsers() async {
    Map<String, dynamic> res = await cosmos.queryCosmos(
        isQuery: true,
        url:
            'https://ideabarrel.documents.azure.com:443/dbs/Ideas/colls/Users/docs',
        method: 'GET');
    List<dynamic> maps = res["Documents"];
    return List.generate(maps.length, (i) {
      return User(
          name: maps[i]['name'],
          uuid: maps[i]['id'],
          totalSwiped: maps[i]['totalSwiped']);
    });
  }

  // returns true if success, false if not
  Future<bool> postIdea(Idea idea) async {
    String micros = DateTime.now().microsecondsSinceEpoch.toString();
    final Map<String, dynamic> body = {
      "id": micros,
      "title": idea.title,
      "description": idea.description,
      "submittedAt": DateTime.now().millisecondsSinceEpoch,
      "imgs": idea.imgs,
      "submitterUID": idea.submitterUID,
      "score": 0,
      "totalLikes": 0,
      "totalDislikes": 0,
      "department": idea.department.toString(),
      "comments": [],
      "trending": false,
      "approved": false,
    };

    if (kDebugMode) print(jsonEncode(body));

    Map<String, dynamic> res = await cosmos.queryCosmos(
        url:
            'https://ideabarrel.documents.azure.com:443/dbs/Ideas/colls/Ideas/docs',
        method: 'POST',
        body: body,
        isQuery: false,
        micros: micros);

    if (kDebugMode) print(res);
    return true;
  }

  // returns true if success, false if not
  Future<bool> registerUser(String uuid, String name) async {
    final Map<String, dynamic> body = {
      "id": uuid,
      "name": name,
      'totalSwiped': 0,
      "createdAt": DateTime.now().millisecondsSinceEpoch
    };

    if (kDebugMode) print(jsonEncode(body));

    Map<String, dynamic> res = await cosmos.queryCosmos(
        url:
            'https://ideabarrel.documents.azure.com:443/dbs/Ideas/colls/Users/docs',
        method: 'POST',
        body: body,
        isQuery: false,
        micros: uuid);

    if (kDebugMode) print(res);
    return true;
  }
}
