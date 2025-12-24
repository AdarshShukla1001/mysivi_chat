import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../models/message_model.dart';
import '../../../../../core/network/network_exception.dart'; // Will create this next

abstract class ReceiverMessageRemoteDataSource {
  Future<MessageModel> fetchRandomMessage();
}

class ReceiverMessageRemoteDataSourceImpl
    implements ReceiverMessageRemoteDataSource {
  final http.Client client;

  ReceiverMessageRemoteDataSourceImpl({required this.client});

  @override
  Future<MessageModel> fetchRandomMessage() async {
    // Generate a random skip to get a random message. Total is usually 340.
    final randomSkip = Random().nextInt(300);
    final url = Uri.parse(
      'https://dummyjson.com/comments?limit=1&skip=$randomSkip',
    );

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List comments = data['comments'];

        if (comments.isNotEmpty) {
          return MessageModel.fromJson(comments.first);
        } else {
          throw ServerException('No comments found');
        }
      } else {
        throw ServerException(
          'Failed to fetch messages: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
