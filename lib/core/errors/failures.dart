abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Error']);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = 'Unable to connect to server']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Error']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
