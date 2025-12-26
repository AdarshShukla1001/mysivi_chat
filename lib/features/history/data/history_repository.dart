import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:mysivi_chat/services/history_db_service/history_db_service.dart';
import '../domain/chat_history_model.dart';

class HistoryRepository {
  final HistoryService _historyService;

  HistoryRepository(this._historyService);

  Future<DataState<List<ChatHistory>>> getHistory() async {
    return await _historyService.getHistory();
  }
}
