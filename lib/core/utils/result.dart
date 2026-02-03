sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(String) error,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    }
    return error((this as Failure<T>).message);
  }
}

class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.message);

  final String message;
}
