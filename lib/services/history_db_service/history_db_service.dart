import 'package:mysivi_chat/core/resources/data_state.dart';
import 'package:mysivi_chat/features/history/domain/chat_history_model.dart';

abstract class HistoryService {
  Future<DataState<List<ChatHistory>>> getHistory();
}
