import '../../core/models/address_suggestion.dart';
import '../datasources/api/dadata/dto/dadata_suggestion_dto.dart';

/// Mapper for converting DaData DTOs to AddressSuggestion entities
class AddressMapper {
  /// Convert DaDataSuggestionDto to AddressSuggestion
  static AddressSuggestion fromDto(DaDataSuggestionDto dto) {
    return AddressSuggestion(
      value: dto.value,
      unrestrictedValue: dto.unrestrictedValue,
      data: AddressData(
        city: dto.data.city,
        cityFiasId: dto.data.cityFiasId,
        cityWithType: dto.data.cityWithType,
        street: dto.data.street,
        streetWithType: dto.data.streetWithType,
        house: dto.data.house,
        block: dto.data.block,
        flat: dto.data.flat,
        postalCode: dto.data.postalCode,
        geoLat: _parseDouble(dto.data.geoLat),
        geoLon: _parseDouble(dto.data.geoLon),
        region: dto.data.region,
        regionWithType: dto.data.regionWithType,
      ),
    );
  }

  /// Convert list of DTOs to AddressSuggestions
  static List<AddressSuggestion> fromDtoList(List<DaDataSuggestionDto> dtos) {
    return dtos.map(fromDto).toList();
  }

  static double? _parseDouble(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value);
  }
}
