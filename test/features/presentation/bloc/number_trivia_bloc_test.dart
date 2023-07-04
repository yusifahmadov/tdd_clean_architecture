import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean_architecture/core/error/failures.dart';
import 'package:tdd_clean_architecture/core/usecase/usecase.dart';
import 'package:tdd_clean_architecture/core/util/input_converter.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomTrivia, InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomTrivia mockGetRandomTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomTrivia = MockGetRandomTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomTrivia: mockGetRandomTrivia,
        inputConverter: mockInputConverter);
  });

  test(
    "initialState should be Empty",
    () async {
      expect(bloc.state, Empty());
    },
  );
  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnSignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
    test(
      "should call the InputConverter to validate and convert string to unsigned integer",
      () async {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(tNumberParsed))
            .thenAnswer((_) async => Right(tNumberTrivia));
        bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(mockInputConverter.stringToUnSignedInteger(any));
        verify(mockInputConverter.stringToUnSignedInteger(tNumberString));
      },
    );

    test(
        'should return input converter failure if conversion is not successful',
        () async* {
      //arrange
      when(mockInputConverter.stringToUnSignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      final expected = [
        Empty(),
        const Error(errorMessage: INVALID_FAILURE_MESSAGE),
      ];
      //assert later
      expectLater(bloc.state, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForConcreteNumber(numberString: "-3"));
    });
    test(
      "should get data from concrete usecase",
      () async {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(tNumberParsed))
            .thenAnswer((_) async => Right(tNumberTrivia));
        bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        verify(mockGetConcreteNumberTrivia(tNumberParsed));
      },
    );
    test(
      "should emit [Loading,Loaded] when data is successfully",
      () async* {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(tNumberParsed))
            .thenAnswer((_) async => Right(tNumberTrivia));

        bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));

        final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
        verify(mockInputConverter.stringToUnSignedInteger(tNumberString));
        verify(mockGetConcreteNumberTrivia(tNumberParsed));
        expectLater(bloc.state, emitsInOrder(expected));
      },
    );
    test(
      "should emit [Loading,Error] when data is unsuccessfull",
      () async* {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(tNumberParsed))
            .thenAnswer((_) async => Left(ServerFailure()));

        bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));

        final expected = [
          Empty(),
          Loading(),
          const Error(errorMessage: SERVER_FAILURE_MESSAGE)
        ];
        verify(mockInputConverter.stringToUnSignedInteger(tNumberString));
        verify(mockGetConcreteNumberTrivia(tNumberParsed));
        expectLater(bloc.state, emitsInOrder(expected));
      },
    );
    test(
      "should emit [Loading,Error] with a proper message for the error when getting data fails",
      () async* {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(tNumberParsed))
            .thenAnswer((_) async => Left(CacheFailure()));

        bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));

        final expected = [
          Empty(),
          Loading(),
          const Error(errorMessage: CACHE_FAILURE_MESSAGE)
        ];
        verify(mockInputConverter.stringToUnSignedInteger(tNumberString));
        verify(mockGetConcreteNumberTrivia(tNumberParsed));
        expectLater(bloc.state, emitsInOrder(expected));
      },
    );
  });
  group('GetRandomTrivia', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      "should get data from random usecase",
      () async {
        when(mockGetRandomTrivia(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomTrivia(NoParams()));
        verify(mockGetRandomTrivia(NoParams()));
      },
    );
    test(
      "should emit [Loading,Loaded] when data is successfully",
      () async* {
        when(mockGetRandomTrivia(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));

        bloc.add(GetTriviaForRandomNumber());

        final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];

        verify(mockGetRandomTrivia(NoParams()));
        expectLater(bloc.state, emitsInOrder(expected));
      },
    );
    test(
      "should emit [Loading,Error] when data is unsuccessfull",
      () async* {
        when(mockGetRandomTrivia(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));

        bloc.add(GetTriviaForRandomNumber());

        final expected = [
          Empty(),
          Loading(),
          const Error(errorMessage: SERVER_FAILURE_MESSAGE)
        ];

        verify(mockGetRandomTrivia(NoParams()));
        expectLater(bloc.state, emitsInOrder(expected));
      },
    );
    test(
      "should emit [Loading,Error] with a proper message for the error when getting data fails",
      () async* {
        when(mockGetRandomTrivia(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));

        bloc.add(GetTriviaForRandomNumber());

        final expected = [
          Empty(),
          Loading(),
          const Error(errorMessage: CACHE_FAILURE_MESSAGE)
        ];

        verify(mockGetRandomTrivia(NoParams()));
        expectLater(bloc.state, emitsInOrder(expected));
      },
    );
  });
}
