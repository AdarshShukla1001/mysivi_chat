import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:mysivi_chat/services/dictionary_service/dictionary_service_imp.dart';
import 'package:mysivi_chat/features/chat/domain/models/word_definition_model.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late DictionaryServiceImp dictionaryService;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    dictionaryService = DictionaryServiceImp(client: mockHttpClient);
  });

  group('DictionaryServiceImp', () {
    test('fetchDefinition returns WordDefinitionModel on success', () async {
      final mockJson = [
        {
          'word': 'hello',
          'phonetic': 'hello',
          'meanings': [
            {
              'partOfSpeech': 'exclamation',
              'definitions': [
                {'definition': 'used as a greeting'},
              ],
            },
          ],
        },
      ];

      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockJson), 200));

      final result = await dictionaryService.fetchDefinition('hello');

      expect(result, isA<WordDefinitionModel>());
      expect(result?.word, 'hello');
    });

    test('fetchDefinition returns null on 404', () async {
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final result = await dictionaryService.fetchDefinition('asdfghjkl');

      expect(result, isNull);
    });

    test('fetchDefinition returns null on exception', () async {
      when(() => mockHttpClient.get(any())).thenThrow(Exception());

      final result = await dictionaryService.fetchDefinition('hello');

      expect(result, isNull);
    });
  });
}
