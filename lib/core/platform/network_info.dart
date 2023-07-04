import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionCheckerPlus;
  NetworkInfoImpl({required this.connectionCheckerPlus});
  @override
  Future<bool> get isConnected => connectionCheckerPlus.hasConnection;
}
