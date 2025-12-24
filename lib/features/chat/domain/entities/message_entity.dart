import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String body;
  final int? postId;
  final int likes;
  final bool isMe;

  const MessageEntity({
    required this.id,
    required this.body,
    required this.likes,
    required this.isMe,
    this.postId,
  });

  @override
  List<Object?> get props => [id, body, postId, likes, isMe];
}
