import 'package:dio/dio.dart';

import '../../../../core/models/geo_point.dart';
import '../../../../core/network/dio_client.dart';
import 'dto/overpass_pharmacy_dto.dart';

/// Data source for Overpass API (OpenStreetMap data queries)
abstract class OverpassApiDataSource {
  /// Get pharmacies within a radius of a point
  Future<List<OverpassElementDto>> getPharmaciesInRadius(
    double lat,
    double lon,
    int radiusMeters,
  );

  /// Get pharmacies within a bounding box
  Future<List<OverpassElementDto>> getPharmaciesInBounds(MapBounds bounds);

  /// Get pharmacies with name filter
  Future<List<OverpassElementDto>> getPharmaciesByName(
    MapBounds bounds,
    String nameFilter,
  );
}

class OverpassApiDataSourceImpl implements OverpassApiDataSource {
  final Dio _dio;

  OverpassApiDataSourceImpl({Dio? dio})
      : _dio = dio ?? DioClient.overpass().dio;

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
    try {
      final response = await _dio.post(
        '',
        data: {'data': query},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final dto = OverpassResponseDto.fromJson(response.data);
      return dto.elements;
    } on DioException catch (e) {
      throw e.asApiException;
    }
  }
}
