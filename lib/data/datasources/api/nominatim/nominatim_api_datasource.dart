import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import 'dto/nominatim_place_dto.dart';
import 'nominatim_retrofit_api.dart';

/// Data source for Nominatim (OpenStreetMap geocoding) API
abstract class NominatimApiDataSource {
  Future<NominatimPlaceDto?> geocodeCity(String cityName);

  Future<List<NominatimPlaceDto>> searchPlaces(String query, {int limit = 5});

  Future<NominatimPlaceDto?> reverseGeocode(double lat, double lon);
}

class NominatimApiDataSourceImpl implements NominatimApiDataSource {
  final NominatimRetrofitApi _api;

  NominatimApiDataSourceImpl({NominatimRetrofitApi? api})
      : _api = api ?? NominatimRetrofitApi(DioClient.nominatim().dio);

  @override
  Future<NominatimPlaceDto?> geocodeCity(String cityName) async {
    if (cityName.trim().isEmpty) return null;

    try {
      final response = await _api.geocodeCity(
        cityName,
        'json',
        1,
        1,
        'ru',
      );
      return response.isNotEmpty ? response.first : null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<NominatimPlaceDto>> searchPlaces(
    String query, {
    int limit = 5,
  }) async {
    if (query.trim().isEmpty) return [];

    try {
      return await _api.searchPlaces(
        query,
        'json',
        limit,
        1,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NominatimPlaceDto?> reverseGeocode(double lat, double lon) async {
    try {
      final response = await _api.reverseGeocode(
        lat,
        lon,
        'json',
        1,
      );
      return response;
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
