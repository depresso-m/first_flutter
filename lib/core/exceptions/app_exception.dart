abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.originalError});

  factory NetworkException.noConnection() => const NetworkException(
        'Отсутствует подключение к интернету',
        code: 'NO_CONNECTION',
      );

  factory NetworkException.timeout() => const NetworkException(
        'Превышено время ожидания ответа от сервера',
        code: 'TIMEOUT',
      );

  factory NetworkException.serverError([String? message]) => NetworkException(
        message ?? 'Ошибка сервера. Попробуйте позже',
        code: 'SERVER_ERROR',
      );
}

class AuthException extends AppException {
  const AuthException(super.message, {super.code, super.originalError});

  factory AuthException.invalidCredentials() => const AuthException(
        'Неверный email или пароль',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthException.emailAlreadyExists() => const AuthException(
        'Пользователь с таким email уже существует',
        code: 'EMAIL_EXISTS',
      );

  factory AuthException.weakPassword() => const AuthException(
        'Пароль слишком простой',
        code: 'WEAK_PASSWORD',
      );

  factory AuthException.invalidEmail() => const AuthException(
        'Некорректный email',
        code: 'INVALID_EMAIL',
      );

  factory AuthException.notAuthenticated() => const AuthException(
        'Пользователь не авторизован',
        code: 'NOT_AUTHENTICATED',
      );

  factory AuthException.emptyFields() => const AuthException(
        'Заполните все обязательные поля',
        code: 'EMPTY_FIELDS',
      );
}

class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.originalError});

  factory CacheException.notFound() => const CacheException(
        'Данные не найдены в кэше',
        code: 'NOT_FOUND',
      );

  factory CacheException.writeError() => const CacheException(
        'Ошибка записи в кэш',
        code: 'WRITE_ERROR',
      );
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.originalError});

  factory ValidationException.emptyCart() => const ValidationException(
        'Корзина пуста',
        code: 'EMPTY_CART',
      );

  factory ValidationException.invalidQuantity() => const ValidationException(
        'Некорректное количество товара',
        code: 'INVALID_QUANTITY',
      );

  factory ValidationException.insufficientPoints() => const ValidationException(
        'Недостаточно баллов',
        code: 'INSUFFICIENT_POINTS',
      );
}
