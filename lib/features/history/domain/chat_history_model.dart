import '../../chat/domain/chat_model.dart';
import '../../users/domain/user_model.dart';

class ChatHistoryModel {
  final String chatId;
  final UserModel user;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatHistoryModel({
    required this.chatId,
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatHistoryModel.fromChat(ChatModel chat) {
    final lastMsg = chat.messages.isNotEmpty ? chat.messages.last : null;
    return ChatHistoryModel(
      chatId: chat.chatId,
      user: chat.user,
      lastMessage: lastMsg?.text ?? '',
      lastMessageTime: lastMsg?.timestamp ?? DateTime.now(),
    );
  }
}
