import 'message_model.dart';
import '../../users/domain/user_model.dart';

class ChatModel {
  final String chatId;
  final UserModel user;
  final List<MessageModel> messages;

  const ChatModel({
    required this.chatId,
    required this.user,
    required this.messages,
  });

  ChatModel copyWith({
    String? chatId,
    UserModel? user,
    List<MessageModel>? messages,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      user: user ?? this.user,
      messages: messages ?? this.messages,
    );
  }
}
