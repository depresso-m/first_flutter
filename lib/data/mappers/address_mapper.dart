import '../../core/models/address_suggestion.dart';
import '../datasources/api/dadata/dto/dadata_suggestion_dto.dart';

/// Extension для преобразования DaDataSuggestionDto в AddressSuggestion
extension DaDataSuggestionDtoMapper on DaDataSuggestionDto {
  /// Преобразует DTO в бизнес-модель AddressSuggestion
  AddressSuggestion toModel() {
    return AddressSuggestion(
      value: value,
      unrestrictedValue: unrestrictedValue,
      data: data.toModel(),
    );
  }
}

/// Extension для преобразования DaDataDataDto в AddressData
extension DaDataDataDtoMapper on DaDataDataDto {
  /// Преобразует DTO в бизнес-модель AddressData
  AddressData toModel() {
    return AddressData(
      city: city,
      cityFiasId: cityFiasId,
      cityWithType: cityWithType,
      street: street,
      streetWithType: streetWithType,
      house: house,
      block: block,
      flat: flat,
      postalCode: postalCode,
      geoLat: geoLat != null ? double.tryParse(geoLat!) : null,
      geoLon: geoLon != null ? double.tryParse(geoLon!) : null,
      region: region,
      regionWithType: regionWithType,
    );
  }
}

/// Extension для преобразования списка DTO в список моделей
extension DaDataSuggestionDtoListMapper on List<DaDataSuggestionDto> {
  /// Преобразует список DTO в список AddressSuggestion
  List<AddressSuggestion> toModelList() {
    return map((dto) => dto.toModel()).toList();
  }
}
