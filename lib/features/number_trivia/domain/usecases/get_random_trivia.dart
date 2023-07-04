import 'package:tdd_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_clean_architecture/core/usecase/usecase.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomTrivia implements UseCase<NumberTrivia, NoParams> {
  NumberTriviaRepository repository;
  GetRandomTrivia({required this.repository});
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) {
    return repository.getRandomNumberTrivia();
  }
}
