import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:mysivi_chat/services/api_service/api_service.dart';

class ApiServiceImp implements ApiService {
  final http.Client client;
  static const _baseUrl = 'https://dummyjson.com/comments';

  ApiServiceImp({http.Client? client}) : client = client ?? http.Client();

  /// Fetches a random comment each time
  @override
  Future<String> fetchRandomComment() async {
    try {
      // Random comment id between 1–340 (dummyjson range)
      final randomId = Random().nextInt(340) + 1;

      final response = await client.get(Uri.parse('$_baseUrl/$randomId'));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;

        final comment = decoded['body'];
        if (comment is String && comment.isNotEmpty) {
          return comment;
        }

        throw Exception('Invalid comment data');
      } else {
        throw Exception('API failed with status ${response.statusCode}');
      }
    } catch (e) {
      // Centralized error point
      throw Exception('Unable to fetch random comment');
    }
  }
}
