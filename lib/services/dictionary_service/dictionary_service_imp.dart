import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/chat/domain/models/word_definition_model.dart';
import 'dictionary_service.dart';

class DictionaryServiceImp implements DictionaryService {
  final http.Client client;

  DictionaryServiceImp({http.Client? client})
    : client = client ?? http.Client();

  @override
  Future<WordDefinitionModel?> fetchDefinition(String word) async {
    try {
      final response = await client.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return WordDefinitionModel.fromJson(data[0]);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
