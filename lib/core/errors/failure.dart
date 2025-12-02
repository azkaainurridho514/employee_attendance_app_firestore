abstract class Failure {
  final String errorMessage;
  final String? statusCode;
  const Failure({required this.errorMessage, this.statusCode});
}

class ServerFailure extends Failure {
  ServerFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class CacheFailure extends Failure {
  CacheFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class NoFailure extends Failure {
  NoFailure({required String succesMessage})
      : super(errorMessage: succesMessage);
}
