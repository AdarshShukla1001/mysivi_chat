enum MessageType { sender, receiver }

class MessageModel {
  final String id;
  final String chatId;
  final String text;
  final MessageType type;
  final DateTime timestamp;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.text,
    required this.type,
    required this.timestamp,
  });

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? text,
    MessageType? type,
    DateTime? timestamp,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      text: text ?? this.text,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
