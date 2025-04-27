import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:salus_gym/data/local/sqlite/migrations/20250422_initial.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqliteDB {
  static Database? _instance;

  static Future<Database> get instance async {
    _instance ??= await SqliteDB._openSQLite();
    return _instance!;
  }

  static Future<Database> _openSQLite() async {
    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir =
        await getApplicationDocumentsDirectory();
    String dbPath = p.join(appDocumentsDir.path, "SalusGym", "salus_gym.db");

    var db = await databaseFactory.openDatabase(dbPath);

    await db.execute(SQLiteMigration20250422Initial.sql);
    return db;
  }
}
