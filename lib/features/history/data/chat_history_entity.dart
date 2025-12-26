class ChatHistoryEntity {
  final String chatId;
  final String userName;
  final String lastMessage;
  final String lastChatTime;

  const ChatHistoryEntity({
    required this.chatId,
    required this.userName,
    required this.lastMessage,
    required this.lastChatTime,
  });
}
