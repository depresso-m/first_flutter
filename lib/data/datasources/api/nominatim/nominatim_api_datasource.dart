import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/api_exception.dart';
import 'dto/nominatim_place_dto.dart';

/// Data source for Nominatim (OpenStreetMap geocoding) API
abstract class NominatimApiDataSource {
  /// GET /search?q={city}&format=json&limit=1
  /// Geocode a city name to coordinates
  Future<NominatimPlaceDto?> geocodeCity(String cityName);

  /// GET /search?q={query}&format=json&limit=5
  /// Search for places by query
  Future<List<NominatimPlaceDto>> searchPlaces(String query, {int limit = 5});

  /// GET /reverse?lat={lat}&lon={lon}&format=json
  /// Reverse geocode coordinates to address
  Future<NominatimPlaceDto?> reverseGeocode(double lat, double lon);
}

class NominatimApiDataSourceImpl implements NominatimApiDataSource {
  final http.Client _client;

  NominatimApiDataSourceImpl({http.Client? client})
      : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'User-Agent': ApiConstants.userAgent,
        'Accept': 'application/json',
      };

  @override
  Future<NominatimPlaceDto?> geocodeCity(String cityName) async {
    if (cityName.trim().isEmpty) return null;

    final uri = Uri.parse('${ApiConstants.nominatimBaseUrl}/search').replace(
      queryParameters: {
        'q': cityName,
        'format': 'json',
        'limit': '1',
        'addressdetails': '1',
        'countrycodes': 'ru', // Restrict to Russia
      },
    );

    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        if (data.isEmpty) return null;
        return NominatimPlaceDto.fromJson(data.first as Map<String, dynamic>);
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

  @override
  Future<List<NominatimPlaceDto>> searchPlaces(
    String query, {
    int limit = 5,
  }) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse('${ApiConstants.nominatimBaseUrl}/search').replace(
      queryParameters: {
        'q': query,
        'format': 'json',
        'limit': limit.toString(),
        'addressdetails': '1',
      },
    );

    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data
            .map((e) => NominatimPlaceDto.fromJson(e as Map<String, dynamic>))
            .toList();
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

  @override
  Future<NominatimPlaceDto?> reverseGeocode(double lat, double lon) async {
    final uri = Uri.parse('${ApiConstants.nominatimBaseUrl}/reverse').replace(
      queryParameters: {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'format': 'json',
        'addressdetails': '1',
      },
    );

    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data.containsKey('error')) return null;
        return NominatimPlaceDto.fromJson(data);
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
