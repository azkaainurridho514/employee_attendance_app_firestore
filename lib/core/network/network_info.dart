import 'package:data_connection_checker_tv/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(DataConnectionChecker dataConnectionChecker);

  @override
  Future<bool> get isConnected async {
    // Implementasi check internet connection
    // Bisa pakai connectivity_plus package
    return true; // Simplified
  }
}
