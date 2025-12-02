abstract class Failure {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});
}

class ServerFailure extends Failure {
  const ServerFailure({required String message, int? code})
    : super(message: message, code: code);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure() : super(message: 'No internet connection');
}

class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}
