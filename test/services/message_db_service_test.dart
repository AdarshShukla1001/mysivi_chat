import 'package:flutter_test/flutter_test.dart';
import 'package:mysivi_chat/features/chat/domain/entities/message_entity.dart';
import 'package:mysivi_chat/services/message_db_service/message_db_service_imp.dart';
import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late MessageDbServiceImpl messageDbService;
  late Database database;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    database = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id TEXT PRIMARY KEY,
            chat_id TEXT,
            message TEXT,
            owner TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
    messageDbService = MessageDbServiceImpl(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  group('MessageDbServiceImpl', () {
    test(
      'insertMessage correctly inserts a message and triggers stream',
      () async {
        final message = MessageEntity(
          id: '1',
          chatId: 'chat1',
          message: 'Hello',
          owner: 'user',
          timestamp: DateTime.now().toIso8601String(),
        );

        final result = await messageDbService.insertMessage(message);

        expect(result, isA<DataSuccess>());

        final messages = await messageDbService.getMessages('chat1');
        expect(messages.data?.length, 1);
        expect(messages.data?.first.message, 'Hello');
      },
    );

    test('getMessages returns filtered and ordered messages', () async {
      final m1 = MessageEntity(
        id: '1',
        chatId: 'chat1',
        message: 'First',
        owner: 'user',
        timestamp: DateTime.now()
            .subtract(const Duration(minutes: 5))
            .toIso8601String(),
      );
      final m2 = MessageEntity(
        id: '2',
        chatId: 'chat1',
        message: 'Second',
        owner: 'bot',
        timestamp: DateTime.now().toIso8601String(),
      );
      final m3 = MessageEntity(
        id: '3',
        chatId: 'chat2',
        message: 'Other',
        owner: 'user',
        timestamp: DateTime.now().toIso8601String(),
      );

      await messageDbService.insertMessage(m1);
      await messageDbService.insertMessage(m2);
      await messageDbService.insertMessage(m3);

      final result = await messageDbService.getMessages('chat1');
      expect(result.data?.length, 2);
      expect(result.data?[0].message, 'First');
      expect(result.data?[1].message, 'Second');
    });

    test('messageStream yields new messages on insert', () async {
      final message = MessageEntity(
        id: '1',
        chatId: 'chat1',
        message: 'Stream Test',
        owner: 'user',
        timestamp: DateTime.now().toIso8601String(),
      );

      expectLater(messageDbService.messageStream, emits(message));

      await messageDbService.insertMessage(message);
    });
  });
}
