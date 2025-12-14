/// A Result type for handling success and error cases
sealed class Result<T, E> {
  const Result();

  /// Create a success result
  factory Result.success(T value) = Success<T, E>;

  /// Create an error result
  factory Result.error(E error) = Error<T, E>;

  /// Check if this is a success
  bool get isSuccess => this is Success<T, E>;

  /// Check if this is an error
  bool get isError => this is Error<T, E>;

  /// Get the value if success, or null if error
  T? get valueOrNull => switch (this) {
        Success(:final value) => value,
        Error() => null,
      };

  /// Get the error if error, or null if success
  E? get errorOrNull => switch (this) {
        Success() => null,
        Error(:final error) => error,
      };

  /// Map the success value
  Result<R, E> map<R>(R Function(T value) mapper) => switch (this) {
        Success(:final value) => Result.success(mapper(value)),
        Error(:final error) => Result.error(error),
      };

  /// Fold the result into a single value
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(E error) onError,
  }) =>
      switch (this) {
        Success(:final value) => onSuccess(value),
        Error(:final error) => onError(error),
      };

  /// Get value or throw error
  T getOrThrow() => switch (this) {
        Success(:final value) => value,
        Error(:final error) => throw error as Object,
      };

  /// Get value or return default
  T getOrElse(T defaultValue) => switch (this) {
        Success(:final value) => value,
        Error() => defaultValue,
      };
}

/// Success case of Result
final class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

/// Error case of Result
final class Error<T, E> extends Result<T, E> {
  final E error;
  const Error(this.error);
}
