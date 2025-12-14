/// Exception for API-related errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? endpoint;
  final dynamic originalError;

  const ApiException({
    required this.message,
    this.statusCode,
    this.endpoint,
    this.originalError,
  });

  factory ApiException.network({String? endpoint}) => ApiException(
        message: 'Ошибка сети. Проверьте подключение к интернету.',
        endpoint: endpoint,
      );

  factory ApiException.timeout({String? endpoint}) => ApiException(
        message: 'Превышено время ожидания ответа от сервера.',
        endpoint: endpoint,
      );

  factory ApiException.serverError({int? statusCode, String? endpoint}) =>
      ApiException(
        message: 'Ошибка сервера. Попробуйте позже.',
        statusCode: statusCode,
        endpoint: endpoint,
      );

  factory ApiException.notFound({String? endpoint}) => ApiException(
        message: 'Данные не найдены.',
        statusCode: 404,
        endpoint: endpoint,
      );

  factory ApiException.unauthorized({String? endpoint}) => ApiException(
        message: 'Ошибка авторизации.',
        statusCode: 401,
        endpoint: endpoint,
      );

  factory ApiException.badRequest({String? message, String? endpoint}) =>
      ApiException(
        message: message ?? 'Некорректный запрос.',
        statusCode: 400,
        endpoint: endpoint,
      );

  factory ApiException.parseError({String? endpoint, dynamic error}) =>
      ApiException(
        message: 'Ошибка обработки данных.',
        endpoint: endpoint,
        originalError: error,
      );

  factory ApiException.rateLimited({String? endpoint}) => ApiException(
        message: 'Превышен лимит запросов. Попробуйте позже.',
        statusCode: 429,
        endpoint: endpoint,
      );

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (код: $statusCode)' : ''}';
}
