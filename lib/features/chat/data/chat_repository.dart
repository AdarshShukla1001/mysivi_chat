import 'dart:convert';
import 'dart:math';
import '../../../core/network/api_client.dart';
import '../domain/message_model.dart';

class ChatRepository {
  final ApiClient apiClient;

  ChatRepository(this.apiClient);

  Future<MessageModel> fetchReceiverMessage(String chatId) async {
    final randomSkip = Random().nextInt(300);
    final url = Uri.parse(
      'https://dummyjson.com/comments?limit=1&skip=$randomSkip',
    );

    final response = await apiClient.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final body = data['comments'][0]['body'] as String;
      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        text: body,
        type: MessageType.receiver,
        timestamp: DateTime.now(),
      );
    } else {
      throw Exception('Failed to fetch message');
    }
  }
}
