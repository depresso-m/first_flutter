import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/models/geo_point.dart';
import '../../../../core/network/dio_client.dart';
import 'dto/overpass_pharmacy_dto.dart';
import 'overpass_retrofit_api.dart';

/// Data source for Overpass API (OpenStreetMap data queries)
abstract class OverpassApiDataSource {
  Future<List<OverpassElementDto>> getPharmaciesInRadius(
    double lat,
    double lon,
    int radiusMeters,
  );

  Future<List<OverpassElementDto>> getPharmaciesInBounds(MapBounds bounds);

  Future<List<OverpassElementDto>> getPharmaciesByName(
    MapBounds bounds,
    String nameFilter,
  );
}

class OverpassApiDataSourceImpl implements OverpassApiDataSource {
  final OverpassRetrofitApi _api;

  OverpassApiDataSourceImpl({OverpassRetrofitApi? api})
      : _api = api ?? OverpassRetrofitApi(DioClient.overpass().dio);

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
      final response = await _api.executeQuery(query);
      return response.elements;
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
