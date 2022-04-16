import 'package:flutter/material.dart';

import '../ui/screens/new_idea_screen.dart';

class GlobalKeys {
   // --- singleton boilerplate
  static final GlobalKeys _globalKeys = GlobalKeys._internal();
  factory GlobalKeys() {
    return _globalKeys;
  }
  GlobalKeys._internal();
  // ---

  final GlobalKey<NewIdeaScreenState> ideaKey = GlobalKey();
}