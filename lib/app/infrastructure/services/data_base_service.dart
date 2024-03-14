import 'package:ariapp/app/infrastructure/local_data_source/chat_db.dart';
import 'package:ariapp/app/infrastructure/local_data_source/message_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'Aria.db';
    final path = await getDatabasesPath();

    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 6,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async {
    await ChatDB().createTable(database);
    await MessageDB().createTable(database);
  }
}
