class ChatHistory {
  final String chatId;
  final String userName;
  final String lastMessage;
  final DateTime lastChatTime;
  final int colorValue;

  const ChatHistory({
    required this.chatId,
    required this.userName,
    required this.lastMessage,
    required this.lastChatTime,
    this.colorValue = 0xFF9E9E9E, // Default grey
  });

  String get userAvatar =>
      userName.isNotEmpty ? userName[0].toUpperCase() : '?';
}
