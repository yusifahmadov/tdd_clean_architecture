import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

abstract class UseCase<Type, T> {
  Future<Either<Failure, Type>> call(T params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
