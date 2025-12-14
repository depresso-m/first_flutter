/// DTO for DaData API response
class DaDataResponseDto {
  final List<DaDataSuggestionDto> suggestions;

  const DaDataResponseDto({required this.suggestions});

  factory DaDataResponseDto.fromJson(Map<String, dynamic> json) {
    return DaDataResponseDto(
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) =>
                  DaDataSuggestionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// DTO for a single address suggestion
class DaDataSuggestionDto {
  final String value;
  final String unrestrictedValue;
  final DaDataDataDto data;

  const DaDataSuggestionDto({
    required this.value,
    required this.unrestrictedValue,
    required this.data,
  });

  factory DaDataSuggestionDto.fromJson(Map<String, dynamic> json) {
    return DaDataSuggestionDto(
      value: json['value'] as String? ?? '',
      unrestrictedValue: json['unrestricted_value'] as String? ?? '',
      data: DaDataDataDto.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

/// DTO for detailed address data
class DaDataDataDto {
  final String? postalCode;
  final String? country;
  final String? countryIsoCode;
  final String? federalDistrict;
  final String? regionFiasId;
  final String? regionKladrId;
  final String? regionIsoCode;
  final String? regionWithType;
  final String? regionType;
  final String? regionTypeFull;
  final String? region;
  final String? areaFiasId;
  final String? areaWithType;
  final String? area;
  final String? cityFiasId;
  final String? cityKladrId;
  final String? cityWithType;
  final String? cityType;
  final String? cityTypeFull;
  final String? city;
  final String? settlementFiasId;
  final String? settlementWithType;
  final String? settlement;
  final String? streetFiasId;
  final String? streetKladrId;
  final String? streetWithType;
  final String? streetType;
  final String? streetTypeFull;
  final String? street;
  final String? houseFiasId;
  final String? houseKladrId;
  final String? houseType;
  final String? houseTypeFull;
  final String? house;
  final String? blockType;
  final String? blockTypeFull;
  final String? block;
  final String? flatFiasId;
  final String? flatType;
  final String? flatTypeFull;
  final String? flat;
  final String? geoLat;
  final String? geoLon;
  final String? qcGeo;

  const DaDataDataDto({
    this.postalCode,
    this.country,
    this.countryIsoCode,
    this.federalDistrict,
    this.regionFiasId,
    this.regionKladrId,
    this.regionIsoCode,
    this.regionWithType,
    this.regionType,
    this.regionTypeFull,
    this.region,
    this.areaFiasId,
    this.areaWithType,
    this.area,
    this.cityFiasId,
    this.cityKladrId,
    this.cityWithType,
    this.cityType,
    this.cityTypeFull,
    this.city,
    this.settlementFiasId,
    this.settlementWithType,
    this.settlement,
    this.streetFiasId,
    this.streetKladrId,
    this.streetWithType,
    this.streetType,
    this.streetTypeFull,
    this.street,
    this.houseFiasId,
    this.houseKladrId,
    this.houseType,
    this.houseTypeFull,
    this.house,
    this.blockType,
    this.blockTypeFull,
    this.block,
    this.flatFiasId,
    this.flatType,
    this.flatTypeFull,
    this.flat,
    this.geoLat,
    this.geoLon,
    this.qcGeo,
  });

  factory DaDataDataDto.fromJson(Map<String, dynamic> json) {
    return DaDataDataDto(
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      countryIsoCode: json['country_iso_code'] as String?,
      federalDistrict: json['federal_district'] as String?,
      regionFiasId: json['region_fias_id'] as String?,
      regionKladrId: json['region_kladr_id'] as String?,
      regionIsoCode: json['region_iso_code'] as String?,
      regionWithType: json['region_with_type'] as String?,
      regionType: json['region_type'] as String?,
      regionTypeFull: json['region_type_full'] as String?,
      region: json['region'] as String?,
      areaFiasId: json['area_fias_id'] as String?,
      areaWithType: json['area_with_type'] as String?,
      area: json['area'] as String?,
      cityFiasId: json['city_fias_id'] as String?,
      cityKladrId: json['city_kladr_id'] as String?,
      cityWithType: json['city_with_type'] as String?,
      cityType: json['city_type'] as String?,
      cityTypeFull: json['city_type_full'] as String?,
      city: json['city'] as String?,
      settlementFiasId: json['settlement_fias_id'] as String?,
      settlementWithType: json['settlement_with_type'] as String?,
      settlement: json['settlement'] as String?,
      streetFiasId: json['street_fias_id'] as String?,
      streetKladrId: json['street_kladr_id'] as String?,
      streetWithType: json['street_with_type'] as String?,
      streetType: json['street_type'] as String?,
      streetTypeFull: json['street_type_full'] as String?,
      street: json['street'] as String?,
      houseFiasId: json['house_fias_id'] as String?,
      houseKladrId: json['house_kladr_id'] as String?,
      houseType: json['house_type'] as String?,
      houseTypeFull: json['house_type_full'] as String?,
      house: json['house'] as String?,
      blockType: json['block_type'] as String?,
      blockTypeFull: json['block_type_full'] as String?,
      block: json['block'] as String?,
      flatFiasId: json['flat_fias_id'] as String?,
      flatType: json['flat_type'] as String?,
      flatTypeFull: json['flat_type_full'] as String?,
      flat: json['flat'] as String?,
      geoLat: json['geo_lat'] as String?,
      geoLon: json['geo_lon'] as String?,
      qcGeo: json['qc_geo'] as String?,
    );
  }
}
