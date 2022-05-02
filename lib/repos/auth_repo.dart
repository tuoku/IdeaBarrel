import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  // --- singleton boilerplate
  static final AuthRepo _authRepo = AuthRepo._internal();
  factory AuthRepo() {
    return _authRepo;
  }
  AuthRepo._internal();
  // ---

  StreamController<bool> loggedInStream = StreamController<bool>.broadcast();

  Future<String?> getUUID() =>
      SharedPreferences.getInstance().then((value) => value.getString('uuid'));

  logIn(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uuid', uuid);
    loggedInStream.add(true);
  }

  logOut() {
    loggedInStream.add(false);
  }
}
