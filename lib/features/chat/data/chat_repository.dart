import '../../../services/api_service/api_service.dart';
import '../../../services/dictionary_service/dictionary_service.dart';
import '../../../services/message_db_service/message_db_service.dart';
import '../../chat/domain/entities/message_entity.dart';
import '../domain/message_model.dart';
import '../domain/models/word_definition_model.dart';

class ChatRepository {
  final ApiService apiService;
  final MessageDbService messageDbService;
  final DictionaryService dictionaryService;

  ChatRepository(
    this.apiService,
    this.messageDbService,
    this.dictionaryService,
  );

  Future<WordDefinitionModel?> getWordDefinition(String word) async {
    return await dictionaryService.fetchDefinition(word);
  }

  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final result = await messageDbService.getMessages(chatId);
    if (result.data != null) {
      return result.data!.map((e) {
        return MessageModel(
          id: e.id,
          chatId: e.chatId,
          text: e.message,
          type: e.owner == 'user' ? MessageType.sender : MessageType.receiver,
          timestamp: DateTime.parse(e.timestamp),
        );
      }).toList();
    }
    return [];
  }

  Future<void> saveMessage(MessageModel message) async {
    await messageDbService.insertMessage(
      MessageEntity(
        id: message.id,
        chatId: message.chatId,
        message: message.text,
        owner: message.type == MessageType.sender ? 'user' : 'receiver',
        timestamp: message.timestamp.toIso8601String(),
      ),
    );
  }

  Future<MessageModel> fetchReceiverMessage(String chatId) async {
    final body = await apiService.fetchRandomComment();
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      text: body,
      type: MessageType.receiver,
      timestamp: DateTime.now(),
    );
  }
}
