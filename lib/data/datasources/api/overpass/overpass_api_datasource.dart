import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/models/geo_point.dart';
import 'dto/overpass_pharmacy_dto.dart';

/// Data source for Overpass API (OpenStreetMap data queries)
abstract class OverpassApiDataSource {
  /// Get pharmacies within a radius of a point
  /// Query: [out:json];node["amenity"="pharmacy"](around:{radius},{lat},{lon});out;
  Future<List<OverpassElementDto>> getPharmaciesInRadius(
    double lat,
    double lon,
    int radiusMeters,
  );

  /// Get pharmacies within a bounding box
  /// Query: [out:json];node["amenity"="pharmacy"]({s},{w},{n},{e});out;
  Future<List<OverpassElementDto>> getPharmaciesInBounds(MapBounds bounds);

  /// Get pharmacies with name filter
  Future<List<OverpassElementDto>> getPharmaciesByName(
    MapBounds bounds,
    String nameFilter,
  );
}

class OverpassApiDataSourceImpl implements OverpassApiDataSource {
  final http.Client _client;

  OverpassApiDataSourceImpl({http.Client? client})
      : _client = client ?? http.Client();

  @override
  Future<List<OverpassElementDto>> getPharmaciesInRadius(
    double lat,
    double lon,
    int radiusMeters,
  ) async {
    final query = '''
[out:json][timeout:25];
(
  node["amenity"="pharmacy"](around:$radiusMeters,$lat,$lon);
  way["amenity"="pharmacy"](around:$radiusMeters,$lat,$lon);
);
out center;
''';

    return _executeQuery(query);
  }

  @override
  Future<List<OverpassElementDto>> getPharmaciesInBounds(
    MapBounds bounds,
  ) async {
    final query = '''
[out:json][timeout:25];
(
  node["amenity"="pharmacy"](${bounds.south},${bounds.west},${bounds.north},${bounds.east});
  way["amenity"="pharmacy"](${bounds.south},${bounds.west},${bounds.north},${bounds.east});
);
out center;
''';

    return _executeQuery(query);
  }

  @override
  Future<List<OverpassElementDto>> getPharmaciesByName(
    MapBounds bounds,
    String nameFilter,
  ) async {
    final escapedFilter = nameFilter.replaceAll('"', '\\"');
    final query = '''
[out:json][timeout:25];
(
  node["amenity"="pharmacy"]["name"~"$escapedFilter",i](${bounds.south},${bounds.west},${bounds.north},${bounds.east});
  way["amenity"="pharmacy"]["name"~"$escapedFilter",i](${bounds.south},${bounds.west},${bounds.north},${bounds.east});
);
out center;
''';

    return _executeQuery(query);
  }

  Future<List<OverpassElementDto>> _executeQuery(String query) async {
    final uri = Uri.parse(ApiConstants.overpassBaseUrl);

    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: {'data': query},
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final dto = OverpassResponseDto.fromJson(data);
        return dto.elements;
      } else if (response.statusCode == 429) {
        throw ApiException.rateLimited(endpoint: uri.toString());
      } else if (response.statusCode == 504) {
        throw ApiException.timeout(endpoint: uri.toString());
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
