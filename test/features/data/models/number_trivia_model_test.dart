import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTirivaModel = NumberTriviaModel(text: 'test text', number: 1);

  setUp(() async {});

  test('should be a subclass of NumberTrivia Entity', () async {
    expect(tNumberTirivaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model the JSON number is an integer', () async {
      final jsonResponse = jsonDecode(fixtureReader('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonResponse);

      expect(tNumberTirivaModel.text, result.text);
      expect(tNumberTirivaModel.number, result.number);
    });
    test('should return a valid model the JSON number is regarded as a double',
        () async {
      final jsonResponse = jsonDecode(fixtureReader('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonResponse);

      expect(tNumberTirivaModel.text, result.text);
      expect(tNumberTirivaModel.number, result.number);
    });
  });

  group('toJson', () {
    test('should return a json map containing the proper data', () async {
      final result = tNumberTirivaModel.toJson();
      expect(result['number'], tNumberTirivaModel.number);
      expect(result['text'], tNumberTirivaModel.text);
    });
  });
}
