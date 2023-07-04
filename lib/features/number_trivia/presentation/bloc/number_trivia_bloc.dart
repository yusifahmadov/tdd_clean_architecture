import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_clean_architecture/core/error/failures.dart';
import 'package:tdd_clean_architecture/core/usecase/usecase.dart';
import 'package:tdd_clean_architecture/core/util/input_converter.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_trivia.dart';

import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_FAILURE_MESSAGE = 'Invalid Input';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomTrivia getRandomTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) {
      final inputEither =
          inputConverter.stringToUnSignedInteger(event.numberString);

      inputEither.fold((l) {
        emit(const Error(errorMessage: INVALID_FAILURE_MESSAGE));
      }, (r) async {
        emit(Loading());
        final result = await getConcreteNumberTrivia(r);
        _eitherLoadedOrErrorState(result, emit);
      });
    });
    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final result = await getRandomTrivia(NoParams());
      _eitherLoadedOrErrorState(result, emit);
    });
  }

  void _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> result, Emitter<NumberTriviaState> emit) {
    result.fold((l) {
      emit(Error(errorMessage: _mapFailureToString(l)));
    }, (r) {
      emit(Loaded(trivia: r));
    });
  }

  String _mapFailureToString(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;

      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
