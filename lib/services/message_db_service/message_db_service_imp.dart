import 'package:mysivi_chat/core/database/app_database.dart';
import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:mysivi_chat/features/chat/domain/entities/message_entity.dart';
import 'package:mysivi_chat/services/message_db_service/message_db_service.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sqflite/sqflite.dart';

class MessageDbServiceImpl implements MessageDbService {
  final _messageSubject = PublishSubject<MessageEntity?>();
  final Database? _db;

  MessageDbServiceImpl({Database? database}) : _db = database;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    return await AppDatabase.database;
  }

  @override
  Stream<MessageEntity?> get messageStream => _messageSubject.stream;

  @override
  void triggerRefresh() {
    _messageSubject.add(null);
  }

  @override
  Future<DataState<void>> insertMessage(MessageEntity message) async {
    try {
      final database = await _database;
      await database.insert('messages', message.toMap());
      _messageSubject.add(message);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }

  @override
  Future<DataState<List<MessageEntity>>> getMessages(String chatId) async {
    try {
      final database = await _database;
      final res = await database.query(
        'messages',
        where: 'chat_id = ?',
        whereArgs: [chatId],
        orderBy: 'timestamp ASC',
      );
      return DataSuccess(res.map((e) => MessageEntity.fromMap(e)).toList());
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }

  @override
  Future<DataState<List<MessageEntity>>> getAllMessages() async {
    try {
      final database = await _database;
      final res = await database.query('messages');
      return DataSuccess(res.map((e) => MessageEntity.fromMap(e)).toList());
    } catch (e) {
      return DataFailed(Exception(e.toString()));
    }
  }
}
