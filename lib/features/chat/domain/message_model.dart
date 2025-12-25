enum MessageType { sender, receiver }

class MessageModel {
  final String id;
  final String chatId;
  final String text;
  final MessageType type;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.text,
    required this.type,
    required this.timestamp,
  });
}
