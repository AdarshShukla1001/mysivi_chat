import 'package:mysivi_chat/features/chat/data/models/message_model.dart';

 
abstract class LocalMessageDataSource {
  Future<void> saveMessage(MessageModel message);
  Future<List<MessageModel>> getMessages();
}

class LocalMessageDataSourceImpl implements LocalMessageDataSource {
  final List<MessageModel> _messages = [];

  @override
  Future<void> saveMessage(MessageModel message) async {
    _messages.add(message);
  }

  @override
  Future<List<MessageModel>> getMessages() async {
    return List.from(_messages);
  }
}
