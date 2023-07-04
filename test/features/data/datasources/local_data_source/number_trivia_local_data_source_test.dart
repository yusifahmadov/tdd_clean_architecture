import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_architecture/core/error/exceptions.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel.fromJson(
        jsonDecode(fixtureReader('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixtureReader('trivia_cached.json'));

      final result = await localDataSource.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result.number, tNumberTriviaModel.number);
      expect(result.text, tNumberTriviaModel.text);
    });
    test('should throw CacheException when there is not a cached value',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = localDataSource.getLastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  // group('cacheNumberTrivia', () {
  //   final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
  //   test('should call sharedPreferences to cache data', () async {
  //     await localDataSource.cacheNumberTrivia(tNumberTriviaModel);
  //     final expectedJsonString = json.encode(tNumberTriviaModel);
  //     verify(mockSharedPreferences.setString(
  //         CACHED_NUMBER_TRIVIA, expectedJsonString));
  //   });
  // });
}
