import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_clean_architecture/core/platform/network_info.dart';
import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl =
        NetworkInfoImpl(connectionCheckerPlus: mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test('should forwad the call to InternetConnectionCheckes.hasConnection',
        () async {
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      final result = await networkInfoImpl.isConnected;
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, true);
    });
  });
}
