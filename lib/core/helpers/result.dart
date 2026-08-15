import '../errors/failures.dart';

sealed class Result<S> {
  const Result();

  T fold<T>(T Function(Failure failure) onError, T Function(S data) onSuccess) {
    if (this is Success<S>) {
      return onSuccess((this as Success<S>).data);
    } else if (this is Error<S>) {
      return onError((this as Error<S>).failure);
    }
    throw StateError('Unexpected subclass of Result');
  }
}

class Success<S> extends Result<S> {
  final S data;
  const Success(this.data);
}

class Error<S> extends Result<S> {
  final Failure failure;
  const Error(this.failure);
}
