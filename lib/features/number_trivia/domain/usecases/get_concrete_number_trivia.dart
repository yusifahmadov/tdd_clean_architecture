import 'package:tdd_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_clean_architecture/core/usecase/usecase.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../entities/number_trivia.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, int> {
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(int params) {
    return repository.getConcreteNumberTrivia(params);
  }
}
