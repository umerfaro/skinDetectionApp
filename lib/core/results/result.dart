import '../errors/app_error.dart';

// Generic result wrapper for handling success/error states
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';
}

class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);

  @override
  String toString() => 'Failure(error: $error)';
}

// Extension methods for Result
extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => switch (this) {
    Success<T>(data: final data) => data,
    Failure<T>() => null,
  };

  AppError? get error => switch (this) {
    Success<T>() => null,
    Failure<T>(error: final error) => error,
  };

  R fold<R>(
    R Function(T data) onSuccess,
    R Function(AppError error) onFailure,
  ) {
    return switch (this) {
      Success<T>(data: final data) => onSuccess(data),
      Failure<T>(error: final error) => onFailure(error),
    };
  }
}
