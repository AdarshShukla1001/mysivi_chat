import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.body,
    required super.likes,
    required super.isMe,
    super.postId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'].toString(),
      body: json['body'],
      likes: json['likes'] ?? 0,
      isMe: false, // API messages are always from "others"
      postId: json['postId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'likes': likes,
      'isMe': isMe,
      'postId': postId,
    };
  }
}
