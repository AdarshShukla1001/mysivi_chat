import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;

  ApiClient(this.client);

  Future<http.Response> get(Uri url) async {
    return await client.get(url);
  }

  // Add more methods if needed (post, etc.)
}
