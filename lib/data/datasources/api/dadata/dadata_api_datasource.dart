import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/api_exception.dart';
import 'dto/dadata_suggestion_dto.dart';

/// Data source for DaData address suggestions API
abstract class DaDataApiDataSource {
  /// Suggest cities
  /// Body: {"query": "query", "from_bound": {"value": "city"}, "to_bound": {"value": "city"}}
  Future<List<DaDataSuggestionDto>> suggestCities(String query);

  /// Suggest streets
  /// Body: {"query": "query", "from_bound": {"value": "street"}, "to_bound": {"value": "street"}}
  Future<List<DaDataSuggestionDto>> suggestStreets(String query);

  /// Suggest full address (no restrictions)
  /// Body: {"query": "query"}
  Future<List<DaDataSuggestionDto>> suggestFullAddress(String query);

  /// Suggest addresses within a specific city
  /// Body: {"query": "query", "locations": [{"city_fias_id": "..."}]}
  Future<List<DaDataSuggestionDto>> suggestByCity(String query, String cityFiasId);

  /// Refine house number
  /// Body: {"query": "query", "from_bound": {"value": "house"}, "to_bound": {"value": "house"}}
  Future<List<DaDataSuggestionDto>> refineHouse(String streetQuery);
}

class DaDataApiDataSourceImpl implements DaDataApiDataSource {
  final http.Client _client;
  final String _apiKey;

  DaDataApiDataSourceImpl({
    http.Client? client,
    String? apiKey,
  })  : _client = client ?? http.Client(),
        _apiKey = apiKey ?? ApiConstants.dadataApiKey;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $_apiKey',
      };

  @override
  Future<List<DaDataSuggestionDto>> suggestCities(String query) async {
    return _suggest({
      'query': query,
      'from_bound': {'value': 'city'},
      'to_bound': {'value': 'city'},
      'count': 10,
    });
  }

  @override
  Future<List<DaDataSuggestionDto>> suggestStreets(String query) async {
    return _suggest({
      'query': query,
      'from_bound': {'value': 'street'},
      'to_bound': {'value': 'street'},
      'count': 10,
    });
  }

  @override
  Future<List<DaDataSuggestionDto>> suggestFullAddress(String query) async {
    return _suggest({
      'query': query,
      'count': 10,
    });
  }

  @override
  Future<List<DaDataSuggestionDto>> suggestByCity(
    String query,
    String cityFiasId,
  ) async {
    return _suggest({
      'query': query,
      'locations': [
        {'city_fias_id': cityFiasId},
      ],
      'count': 10,
    });
  }

  @override
  Future<List<DaDataSuggestionDto>> refineHouse(String streetQuery) async {
    return _suggest({
      'query': streetQuery,
      'from_bound': {'value': 'house'},
      'to_bound': {'value': 'house'},
      'count': 10,
    });
  }

  Future<List<DaDataSuggestionDto>> _suggest(Map<String, dynamic> body) async {
    final uri = Uri.parse(
      '${ApiConstants.dadataBaseUrl}${ApiConstants.dadataSuggestPath}',
    );

    try {
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: json.encode(body),
          )
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return DaDataResponseDto.fromJson(data).suggestions;
      } else if (response.statusCode == 401) {
        throw ApiException.unauthorized(endpoint: uri.toString());
      } else if (response.statusCode == 403) {
        throw const ApiException(
          message: 'Доступ запрещен. Проверьте API ключ DaData.',
          statusCode: 403,
        );
      } else {
        throw ApiException.serverError(
          statusCode: response.statusCode,
          endpoint: uri.toString(),
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException.timeout(endpoint: uri.toString());
      }
      throw ApiException.network(endpoint: uri.toString());
    }
  }
}
