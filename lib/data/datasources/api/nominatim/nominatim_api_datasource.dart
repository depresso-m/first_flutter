import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import 'dto/nominatim_place_dto.dart';

/// Data source for Nominatim (OpenStreetMap geocoding) API
abstract class NominatimApiDataSource {
  /// GET /search?q={city}&format=json&limit=1
  Future<NominatimPlaceDto?> geocodeCity(String cityName);

  /// GET /search?q={query}&format=json&limit=5
  Future<List<NominatimPlaceDto>> searchPlaces(String query, {int limit = 5});

  /// GET /reverse?lat={lat}&lon={lon}&format=json
  Future<NominatimPlaceDto?> reverseGeocode(double lat, double lon);
}

class NominatimApiDataSourceImpl implements NominatimApiDataSource {
  final Dio _dio;

  NominatimApiDataSourceImpl({Dio? dio})
      : _dio = dio ?? DioClient.nominatim().dio;

  @override
  Future<NominatimPlaceDto?> geocodeCity(String cityName) async {
    if (cityName.trim().isEmpty) return null;

    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': cityName,
          'format': 'json',
          'limit': 1,
          'addressdetails': 1,
          'countrycodes': 'ru',
        },
      );

      final data = response.data as List<dynamic>;
      if (data.isEmpty) return null;
      return NominatimPlaceDto.fromJson(data.first as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.asApiException;
    }
  }

  @override
  Future<List<NominatimPlaceDto>> searchPlaces(
    String query, {
    int limit = 5,
  }) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': limit,
          'addressdetails': 1,
        },
      );

      final data = response.data as List<dynamic>;
      return data
          .map((e) => NominatimPlaceDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.asApiException;
    }
  }

  @override
  Future<NominatimPlaceDto?> reverseGeocode(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'format': 'json',
          'addressdetails': 1,
        },
      );

      final data = response.data as Map<String, dynamic>;
      if (data.containsKey('error')) return null;
      return NominatimPlaceDto.fromJson(data);
    } on DioException catch (e) {
      throw e.asApiException;
    }
  }
}
