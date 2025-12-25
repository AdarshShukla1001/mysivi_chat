import '../../users/domain/user_model.dart';
import 'message_model.dart';

class ChatModel {
  final String chatId;
  final UserModel user;
  final List<MessageModel> messages;

  ChatModel({required this.chatId, required this.user, required this.messages});

  ChatModel copyWith({List<MessageModel>? messages}) {
    return ChatModel(
      chatId: chatId,
      user: user,
      messages: messages ?? this.messages,
    );
  }
}
