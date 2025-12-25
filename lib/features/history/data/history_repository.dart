import '../domain/chat_history_model.dart';

class HistoryRepository {
  final Map<String, ChatHistoryModel> _history = {};

  Future<List<ChatHistoryModel>> getHistory() async {
    final list = _history.values.toList();
    list.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return list;
  }

  Future<void> updateHistory(ChatHistoryModel model) async {
    _history[model.chatId] = model;
  }
}
