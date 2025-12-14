import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import 'dto/dadata_suggestion_dto.dart';
import 'dadata_retrofit_api.dart';

/// Data source for DaData address suggestions API
abstract class DaDataApiDataSource {
  Future<List<DaDataSuggestionDto>> suggestCities(String query);

  Future<List<DaDataSuggestionDto>> suggestStreets(String query);

  Future<List<DaDataSuggestionDto>> suggestFullAddress(String query);

  Future<List<DaDataSuggestionDto>> suggestByCity(
    String query,
    String cityFiasId,
  );

  Future<List<DaDataSuggestionDto>> refineHouse(String streetQuery);
}

class DaDataApiDataSourceImpl implements DaDataApiDataSource {
  final DaDataRetrofitApi _api;

  DaDataApiDataSourceImpl({DaDataRetrofitApi? api})
      : _api = api ?? DaDataRetrofitApi(DioClient.dadata().dio);

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

  Future<List<DaDataSuggestionDto>> _suggest(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _api.suggest(body);
      return response.suggestions;
    } catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    return ApiException(
      message: 'Ошибка сети: $error',
      originalError: error,
    );
  }
}
