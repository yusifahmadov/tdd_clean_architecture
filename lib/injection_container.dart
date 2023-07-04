import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_architecture/core/platform/network_info.dart';
import 'package:tdd_clean_architecture/core/util/input_converter.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomTrivia: sl(),
      inputConverter: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => GetRandomTrivia(repository: sl()));

  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          localDataSource: sl(), networkInfo: sl(), remoteDataSource: sl()));

  //Data Sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionCheckerPlus: sl()));

  //! External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<Future<SharedPreferences>>(() async => prefs);
}
