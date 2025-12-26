import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tables.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute(createUsersTable);
        await db.execute(createMessagesTable);
      },
    );
  }
}
