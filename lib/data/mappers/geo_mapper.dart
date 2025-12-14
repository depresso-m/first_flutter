import '../../core/models/geo_point.dart';
import '../datasources/api/nominatim/dto/nominatim_place_dto.dart';

/// Extension для преобразования NominatimPlaceDto в GeoPoint
extension NominatimPlaceDtoMapper on NominatimPlaceDto {
  /// Преобразует DTO в бизнес-модель GeoPoint
  GeoPoint toGeoPoint() {
    return GeoPoint(
      latitude: latitude,
      longitude: longitude,
    );
  }
}

/// Extension для преобразования списка DTO в список моделей
extension NominatimPlaceDtoListMapper on List<NominatimPlaceDto> {
  /// Преобразует список DTO в список GeoPoint
  List<GeoPoint> toGeoPointList() {
    return map((dto) => dto.toGeoPoint()).toList();
  }
}
