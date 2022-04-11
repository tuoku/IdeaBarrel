import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ideabarrel/models/comment.dart';

import '../models/cosmos.dart';
import '../models/idea.dart';

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
        url:
            'https://ideabarrel.documents.azure.com:443/dbs/Ideas/colls/Ideas/docs',
        method: 'GET');
    List<dynamic> maps = res["Documents"];
    return List.generate(maps.length, (i) {
      return Idea(
          title: maps[i]['title'],
          description: maps[i]['description'],
          submittedAt:
              DateTime.fromMillisecondsSinceEpoch(maps[i]['submittedAt'] ?? 0),
          score: maps[i]['score'],
          comments: List.generate(maps[i]['comments'].length, (ii) {
            return Comment(
                commenterUID: maps[i]['comments'][ii]['commenterUID'],
                likes: maps[i]['comments'][ii]['likes'],
                submittedAt: DateTime.fromMillisecondsSinceEpoch(
                    maps[i]['comments'][ii]['submittedAt']),
                text: maps[i]['comments'][ii]['text']);
          }),
          imgs: List.generate(maps[i]['imgs'].length, (iii) {
            return maps[i]['imgs'][iii].toString();
          }),
          submitterUID: maps[i]['submitterUID']);
    });
  }
}
