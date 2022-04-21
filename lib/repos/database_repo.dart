
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRepo {
  static final DatabaseRepo _databaseRepo = DatabaseRepo._internal();

  factory DatabaseRepo() {
    return _databaseRepo;
  }

  DatabaseRepo._internal();

  Database? database;

  Future<void> init() async {
    // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
          'CREATE TABLE swiped(id TEXT, vote INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertSwipe(String id, bool vote) async {
    final db = database;

    await db?.insert(
      'swiped',
      {
        'id': id,
        'vote': vote ? 1 : 0
      },
    );
  }

  Future<Map<String, bool>> getSwiped() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db!.query('swiped');
    Map<String, bool> map = {};
    for (var m in maps) {
      map[m['id']] = (m['vote'] == 1 ? true : false);
    }
   
    return map;
  }

}
