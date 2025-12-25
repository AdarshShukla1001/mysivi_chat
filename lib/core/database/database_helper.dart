import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../features/users/data/models/user_model.dart';
import '../../features/chat/domain/entities/message_entity.dart'; // We might need a model for this, but using entity for now to align with existing code style if possible, or create a model in this file if simple.

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mysivi_chat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      color_value INTEGER NOT NULL
    )
    ''';

    const messageTable = '''
    CREATE TABLE messages (
      id TEXT PRIMARY KEY,
      userId TEXT NOT NULL,
      text TEXT NOT NULL,
      timestamp INTEGER NOT NULL,
      isMe INTEGER NOT NULL,
      likes INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
    )
    ''';

    await db.execute(userTable);
    await db.execute(messageTable);
  }

  // User Methods
  Future<void> createUser(UserModel user) async {
    final db = await instance.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserModel>> getUsers() async {
    final db = await instance.database;
    final result = await db.query('users', orderBy: 'id ASC'); // Or name ASC
    return result.map((json) => UserModel.fromMap(json)).toList();
  }

  // Message Methods
  Future<void> saveMessage(String userId, MessageEntity message) async {
    final db = await instance.database;
    // Define a simple map for message since we don't have a MessageModel yet with toMap
    final messageMap = {
      'id': message.id,
      'userId': userId,
      'text': message.body,
      'timestamp': message.timestamp.millisecondsSinceEpoch,
      'isMe': message.isMe ? 1 : 0,
      'likes': message.likes,
    };

    await db.insert(
      'messages',
      messageMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MessageEntity>> getMessagesForUser(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'messages',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp ASC',
    );

    return result.map((json) {
      return MessageEntity(
        id: json['id'] as String,
        body: json['text'] as String,
        isMe: (json['isMe'] as int) == 1,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          json['timestamp'] as int,
        ),
        likes: json['likes'] as int,
      );
    }).toList();
  }

  // Chat History Helper
  // Get list of users sorted by their last message timestamp
  Future<List<Map<String, dynamic>>> getChatHistory() async {
    final db = await instance.database;

    // Complex query to get users with their last message
    // distinct users join messages, order by message timestamp desc

    final result = await db.rawQuery('''
       SELECT u.*, m.text as lastMessage, m.timestamp as lastMessageTime
       FROM users u
       INNER JOIN messages m ON u.id = m.userId
       WHERE m.timestamp = (
         SELECT MAX(timestamp) FROM messages WHERE userId = u.id
       )
       ORDER BY m.timestamp DESC
     ''');

    return result;
  }
}
