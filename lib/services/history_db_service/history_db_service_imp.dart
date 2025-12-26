import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:mysivi_chat/features/history/domain/chat_history_model.dart';
import 'package:mysivi_chat/services/history_db_service/history_db_service.dart';
import 'package:mysivi_chat/services/message_db_service/message_db_service.dart';
import 'package:mysivi_chat/services/user_db_service/user_db_service.dart';

class HistoryServiceImpl implements HistoryService {
  final MessageDbService messageDb;
  final UserDbService userDb;

  HistoryServiceImpl(this.messageDb, this.userDb);

  @override
  Future<DataState<List<ChatHistory>>> getHistory() async {
    final msgs = await messageDb.getAllMessages();
    final users = await userDb.getUsers();

    if (msgs is DataFailed) return DataFailed(msgs.error!);
    if (users is DataFailed) return DataFailed(users.error!);

    final userMap = {for (final u in users.data!) u.id: u.name};

    final Map<String, ChatHistory> history = {};

    for (final m in msgs.data!) {
      final time = DateTime.parse(m.timestamp);
      final existing = history[m.chatId];

      if (existing == null || time.isAfter(existing.lastChatTime)) {
        history[m.chatId] = ChatHistory(
          chatId: m.chatId,
          userName: userMap[m.chatId] ?? 'Unknown',
          lastMessage: m.message,
          lastChatTime: time,
          colorValue: 0xFF00BCD4, // Teal as default for now
        );
      }
    }

    return DataSuccess(
      history.values.toList()
        ..sort((a, b) => b.lastChatTime.compareTo(a.lastChatTime)),
    );
  }
}
