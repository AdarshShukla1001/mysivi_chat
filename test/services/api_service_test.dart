import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:mysivi_chat/services/api_service/api_service_imp.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiServiceImp apiService;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiService = ApiServiceImp(client: mockHttpClient);
  });

  group('ApiServiceImp', () {
    test(
      'fetchRandomComment returns a comment when the call is successful',
      () async {
        final mockResponse = {'id': 1, 'body': 'This is a test comment'};

        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

        final result = await apiService.fetchRandomComment();

        expect(result, isA<String>());
        expect(result, 'This is a test comment');
        verify(() => mockHttpClient.get(any())).called(1);
      },
    );

    test(
      'fetchRandomComment throws exception when the status code is not 200',
      () async {
        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() => apiService.fetchRandomComment(), throwsException);
      },
    );

    test('fetchRandomComment throws exception on network failure', () async {
      when(
        () => mockHttpClient.get(any()),
      ).thenThrow(Exception('Network Error'));

      expect(() => apiService.fetchRandomComment(), throwsException);
    });
  });
}
