/// Base failure type carried through the domain layer.
///
/// [message] holds a localization key (see the `errors` section of the
/// translation files) or backend-provided human-readable text. Presentation
/// code must translate it with `.tr()` before displaying — `.tr()` returns
/// non-key text unchanged.
abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'errors.server_unavailable']);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = 'errors.connection_unavailable']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'errors.cache_error']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
