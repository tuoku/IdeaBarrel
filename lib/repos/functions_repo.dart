import 'package:http/http.dart' as http;

class FunctionsRepo {
  // --- singleton boilerplate
  static final FunctionsRepo _functionsRepo = FunctionsRepo._internal();
  factory FunctionsRepo() {
    return _functionsRepo;
  }
  FunctionsRepo._internal();
  // ---

  static const _baseUrl = "https://ideabarrel.azurewebsites.net/api";

  Future<bool> voteIdea(bool like, String id, String voterid) async {
    final url = "$_baseUrl/voteIdea?id=$id&like=$like&voterid=$voterid";
    http.Response res = await http.post(Uri.parse(url));
    if (res.statusCode == 200) return true;
    return false;
  }

  Future<bool> addComment(String text, String id, String uuid) async {
    final url = "$_baseUrl/addComment?id=$id&uuid=$uuid&text=$text";
    http.Response res = await http.post(Uri.parse(url));
    if (res.statusCode == 200) return true;
    return false;
  }
}
