import 'package:mysivi_chat/core/resources/data_state.dart';

import '../../features/chat/domain/entities/message_entity.dart';

abstract class MessageDbService {
  Future<DataState<void>> insertMessage(MessageEntity message);
  Future<DataState<List<MessageEntity>>> getMessages(String chatId);
  Future<DataState<List<MessageEntity>>> getAllMessages();
  Stream<MessageEntity?> get messageStream;
  void triggerRefresh();
}
