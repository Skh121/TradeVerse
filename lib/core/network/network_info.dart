import 'package:internet_connection_checker/internet_connection_checker.dart';


abstract interface class INetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements INetworkInfo {
  final InternetConnectionChecker _connectionChecker;

  NetworkInfoImpl()
    : _connectionChecker = InternetConnectionChecker.createInstance();

  @override
  Future<bool> get isConnected async {
    return await _connectionChecker.hasConnection;
  }
}
