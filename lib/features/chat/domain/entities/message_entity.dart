class MessageEntity {
  final String id;
  final String chatId;
  final String message;
  final String owner; // 'user' | 'receiver'
  final String timestamp; // ISO String

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.message,
    required this.owner,
    required this.timestamp,
  });

  factory MessageEntity.fromMap(Map<String, dynamic> map) {
    return MessageEntity(
      id: map['id'],
      chatId: map['chat_id'],
      message: map['message'],
      owner: map['owner'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_id': chatId,
      'message': message,
      'owner': owner,
      'timestamp': timestamp,
    };
  }
}
