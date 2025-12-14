import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import 'dto/dadata_suggestion_dto.dart';

/// Data source for DaData address suggestions API
abstract class DaDataApiDataSource {
  /// Suggest cities
  Future<List<DaDataSuggestionDto>> suggestCities(String query);

  /// Suggest streets
  Future<List<DaDataSuggestionDto>> suggestStreets(String query);

  /// Suggest full address (no restrictions)
  Future<List<DaDataSuggestionDto>> suggestFullAddress(String query);

  /// Suggest addresses within a specific city
  Future<List<DaDataSuggestionDto>> suggestByCity(String query, String cityFiasId);

  /// Refine house number
  Future<List<DaDataSuggestionDto>> refineHouse(String streetQuery);
}

class DaDataApiDataSourceImpl implements DaDataApiDataSource {
  final Dio _dio;

  DaDataApiDataSourceImpl({Dio? dio})
      : _dio = dio ?? DioClient.dadata().dio;

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
    try {
      final response = await _dio.post(
        ApiConstants.dadataSuggestPath,
        data: body,
      );

      return DaDataResponseDto.fromJson(response.data).suggestions;
    } on DioException catch (e) {
      throw e.asApiException;
    }
  }
}
