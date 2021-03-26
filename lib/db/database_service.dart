/*
* Singleton
* class contains connection to the sqlite database
*/
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _instance =
      DatabaseService._privateConstructor();

  DatabaseService._privateConstructor();

  factory DatabaseService() {
    return _instance;
  }

  // single database connection
  static Database _database;

  // getter foor the database connection
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    // TODO refactor and fix this method
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, "secret_santa_database_7.db");

    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      // Copy from asset
      ByteData data =
          await rootBundle.load(join("assets", "secret_santa_database.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }
    // open the database
    _database = await openDatabase(dbPath);
    // Execute this statement since by default foreign key checks are off when database is opened
    _database.execute("PRAGMA foreign_keys=ON");

    return _database;
  }
}
