import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../exceptions/api_exception.dart';

class DioClient {
  final Dio _dio;

  DioClient({
    required String baseUrl,
    Map<String, String>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: connectTimeout ?? ApiConstants.requestTimeout,
            receiveTimeout: receiveTimeout ?? ApiConstants.requestTimeout,
            headers: {
              'Accept': 'application/json',
              ...?headers,
            },
          ),
        ) {
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  factory DioClient.openFda() {
    return DioClient(
      baseUrl: ApiConstants.openFdaBaseUrl,
      headers: {
        'User-Agent': ApiConstants.userAgent,
      },
    );
  }

  factory DioClient.dadata() {
    return DioClient(
      baseUrl: ApiConstants.dadataBaseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${ApiConstants.dadataApiKey}',
      },
    );
  }

  factory DioClient.nominatim() {
    return DioClient(
      baseUrl: ApiConstants.nominatimBaseUrl,
      headers: {
        'User-Agent': ApiConstants.userAgent,
      },
    );
  }

  factory DioClient.overpass() {
    return DioClient(
      baseUrl: ApiConstants.overpassBaseUrl,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('➡️ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ignore: avoid_print
    print('✅ ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('❌ ${err.response?.statusCode ?? 'NETWORK'} ${err.requestOptions.uri}');
    // ignore: avoid_print
    print('   Error: ${err.message}');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final endpoint = err.requestOptions.uri.toString();

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ApiException.timeout(endpoint: endpoint),
          ),
        );
        return;

      case DioExceptionType.connectionError:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ApiException.network(endpoint: endpoint),
          ),
        );
        return;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        ApiException apiException;

        switch (statusCode) {
          case 401:
            apiException = ApiException.unauthorized(endpoint: endpoint);
            break;
          case 403:
            apiException = ApiException(
              message: 'Доступ запрещен',
              statusCode: 403,
              endpoint: endpoint,
            );
            break;
          case 404:
            apiException = ApiException.notFound(endpoint: endpoint);
            break;
          case 429:
            apiException = ApiException.rateLimited(endpoint: endpoint);
            break;
          default:
            apiException = ApiException.serverError(
              statusCode: statusCode,
              endpoint: endpoint,
            );
        }

        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            error: apiException,
          ),
        );
        return;

      default:
        handler.next(err);
    }
  }
}

extension DioExceptionExt on DioException {
  ApiException get asApiException {
    if (error is ApiException) {
      return error as ApiException;
    }
    return ApiException(
      message: message ?? 'Неизвестная ошибка',
      endpoint: requestOptions.uri.toString(),
      originalError: this,
    );
  }
}

