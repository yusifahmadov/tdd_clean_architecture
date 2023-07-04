import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean_architecture/core/error/exceptions.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    remoteDataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async {
      return http.Response(fixtureReader('trivia.json'), 200);
    });
  }

  void setUpMockHttpClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async {
      return http.Response('Something went wrong', 404);
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixtureReader('trivia.json')));
    test(
      """should perform a GET request on a URL with number being the endpoint
      and with aplication/json header""",
      () async {
        setUpMockHttpClientSuccess200();
        remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
        verify(mockClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {"Conten-Type": "application/json"}));
        // expect(actual, matcher)
      },
    );
    test(
      "should return NumberTrivia when the response code is 200 (success)",
      () async {
        setUpMockHttpClientSuccess200();

        final result =
            await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should throw a ServerException when the response code is 404 or other",
      () async {
        setUpMockHttpClientFailure404();
        final call = remoteDataSourceImpl.getConcreteNumberTrivia;
        expect(
            () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixtureReader('trivia.json')));
    test(
      """should perform a GET request on a URL with number being the endpoint
      and with aplication/json header""",
      () async {
        setUpMockHttpClientSuccess200();
        remoteDataSourceImpl.getRandomNumberTrivia();
        verify(mockClient.get(Uri.parse('http://numbersapi.com/random'),
            headers: {"Conten-Type": "application/json"}));
        // expect(actual, matcher)
      },
    );
    test(
      "should return NumberTrivia when the response code is 200 (success)",
      () async {
        setUpMockHttpClientSuccess200();

        final result = await remoteDataSourceImpl.getRandomNumberTrivia();
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should throw a ServerException when the response code is 404 or other",
      () async {
        setUpMockHttpClientFailure404();
        final call = remoteDataSourceImpl.getRandomNumberTrivia;
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
